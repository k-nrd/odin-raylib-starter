package core

import rl "vendor:raylib"
import "core:fmt"

render :: proc(using state: ^State) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.BLACK)

	rl.DrawRectangleV(player_position, {10, 20}, rl.WHITE)
	rl.DrawRectangleV({20, 20}, {10, 10}, rl.RED)
	rl.DrawRectangleV({-30, -20}, {10, 10}, rl.GREEN)

	rl.BeginMode2D(ui_camera())
	rl.DrawText(
		fmt.ctprintf("Step count: %v\nPlayer position: %v", step_count, player_position),
		5,
		5,
		8,
		rl.WHITE,
	)
	rl.EndMode2D()
}
