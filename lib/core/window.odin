package core

import "core:log"
import rl "vendor:raylib"

window_init :: proc() {
	rl.InitWindow(1280, 720, "raylib hot-reload")
	rl.SetTargetFPS(60)
	rl.SetWindowMonitor(0)
	log.debug("Window initialized")
}

window_destroy :: proc() {
	rl.CloseWindow()
	log.debug("Window destroyed")
}

window_step :: proc() -> bool {
	s := state_get()
	update(s)
	render(s)
	return !window_should_close()
}

window_should_close :: proc() -> bool {
	return rl.WindowShouldClose()
}

window_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

window_force_reset :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
