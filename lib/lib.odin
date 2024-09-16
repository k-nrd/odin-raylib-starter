package lib

import "./core"

@(export)
memory :: proc() -> rawptr {
	return core.state_get()
}

@(export)
memory_size :: proc() -> int {
	return core.state_size()
}

@(export)
setup :: proc() {
	core.window_init()
	init()
}

@(export)
step :: proc() -> bool {
	return core.window_step()
}

@(export)
init :: proc() {
	core.state_init()
}

@(export)
load :: proc(mem: rawptr) {
	core.state_load(mem)
}

@(export)
clear :: proc() {
	core.state_destroy()
}

@(export)
destroy :: proc() {
	clear()
	core.window_destroy()
}

@(export)
force_reload :: proc() -> bool {
	return core.window_force_reload()
}

@(export)
force_reset :: proc() -> bool {
	return core.window_force_reset()
}
