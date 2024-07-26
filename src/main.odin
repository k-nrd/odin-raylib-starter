package main

import "core:c/libc"
import "core:dynlib"
import "core:fmt"
import "core:log"
import "core:os"

when ODIN_OS == .Windows {
	DLL_EXT :: ".dll"
} else when ODIN_OS == .Darwin {
	DLL_EXT :: ".dylib"
} else {
	DLL_EXT :: ".so"
}

LIB_NAME :: "game" + DLL_EXT

GameLib :: struct {
	_lib:         dynlib.Library,
	setup:        proc(),
	init:         proc(),
	load:         proc(state: rawptr),
	clear:        proc(),
	step:         proc() -> bool,
	destroy:      proc(),
	memory:       proc() -> rawptr,
	memory_size:  proc() -> int,
	force_reload: proc() -> bool,
	force_reset:  proc() -> bool,
}

api_version := 0

main :: proc() {
	context.logger = log.create_console_logger()

	mod_time, mod_time_ok := read_lib_modification_time()
	if !mod_time_ok do exit_with("Failed to read modification time")

	lib, lib_ok := load_lib()
	if !lib_ok do exit_with("Failed to load game library")

	lib.setup()
	defer lib.destroy()
	defer unload_lib(&lib)

	for current_mod_time := mod_time; lib.step(); {
		mod_time = read_lib_modification_time() or_continue

		reset := lib.force_reset()
		reload := lib.force_reload() || reset || mod_time != current_mod_time
		if !reload do continue

		log.debugf("Reloading lib: last=%v new=%v", current_mod_time, mod_time)
		new_lib := load_lib() or_continue
		log.debug("Reloaded")

		log.debugf("State sizes: old=%v new=%v", lib.memory_size(), new_lib.memory_size())
		if lib.memory_size() != new_lib.memory_size() || reset {
			log.debug("State size changed, live reloading")
			lib.clear()
			new_lib.init()
		} else {
			log.debug("State size did not change, hot reloading")
			new_lib.load(lib.memory())
		}
		unload_lib(&lib)
		lib = new_lib
		current_mod_time = mod_time
	}
}

exit_with :: proc(message: string, code := 1, location := #caller_location) {
	log.error(message, location = location)
	os.exit(code)
}

read_lib_modification_time :: proc() -> (os.File_Time, bool) {
	mod_time, err := os.last_write_time_by_name(LIB_NAME)
	if err != os.ERROR_NONE {
		log.errorf("Failed getting last write time of {0}, error code: {1}", LIB_NAME, err)
		return mod_time, false
	}
	return mod_time, true
}

copy_dll :: proc(to: string) -> bool {
	when ODIN_OS == .Windows {
		command := "copy {0} {1}"
	} else {
		command := "cp {0} {1}"
	}
	exit := libc.system(fmt.ctprintf(command, LIB_NAME, to))
	if exit != 0 {
		fmt.printfln("Failed to copy {0} to {1}", LIB_NAME, to)
		return false
	}
	return true
}

load_lib :: proc() -> (lib: GameLib, ok: bool) {
	// NOTE: this needs to be a relative path for Linux to work.
	game_dll_name := fmt.tprintf(
		"{0}game_{1}" + DLL_EXT,
		"./" when ODIN_OS != .Windows else "",
		api_version,
	)
	copy_dll(game_dll_name) or_return

	_, ok = dynlib.initialize_symbols(&lib, game_dll_name, handle_field_name = "_lib")
	if !ok {
		log.errorf("Failed initializing symbols: {0}", dynlib.last_error())
		return
	}

	api_version += 1
	return
}

unload_lib :: proc(lib: ^GameLib) {
	if lib != nil && !dynlib.unload_library(lib._lib) {
		log.warnf("Failed unloading lib: {0}", dynlib.last_error())
	}
}

@(export)
NvOptimusEnablement: u32 = 1

@(export)
AmdPowerXpressRequestHighPerformance: i32 = 1
