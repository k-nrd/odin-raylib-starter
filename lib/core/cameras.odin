package core

import rl "vendor:raylib"

game_camera :: proc(target: rl.Vector2) -> rl.Camera2D {
	h := f32(rl.GetScreenHeight())
	w := f32(rl.GetScreenWidth())

	return rl.Camera2D{zoom = 1, target = target, offset = {h / 2, w / 2}}
}

ui_camera :: proc() -> rl.Camera2D {
	return rl.Camera2D{zoom = f32(rl.GetScreenHeight()) / 180}
}
