package core

import rl "vendor:raylib"
import la "core:math/linalg"

update :: proc(using state: ^State) {
	dt := rl.GetFrameTime()

	input: Vec2
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		input.y -= 1
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
		input.y += 1
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		input.x -= 1
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		input.x += 1
	}
	input = la.normalize0(input)

	player_position += input * dt * 100
	step_count += 1
}
