package game

import "core:fmt"
import "core:log"
import la "core:math/linalg"
import rl "vendor:raylib"

Vec2f :: [2]f32

State :: struct {
	player_position: Vec2f,
	step_count:      int,
}

state: ^State

@(export)
current_state :: proc() -> rawptr {
	return state
}

@(export)
state_size :: proc() -> int {
	return size_of(State)
}

@(export)
setup :: proc() {
	log.debug("Initializing window")
	rl.InitWindow(1280, 720, "raylib hot-reload")
	rl.SetTargetFPS(60)
	rl.SetWindowMonitor(0)
	init()
}

@(export)
step :: proc() -> bool {
	simulate()
	draw()
	return !rl.WindowShouldClose()
}

simulate :: proc() {
	dt := rl.GetFrameTime()

	input: Vec2f
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		input.y += 1
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
		input.y -= 1
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		input.x += 1
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		input.x -= 1
	}
	input = la.normalize0(input)
	state.player_position += input * dt * 100
	state.step_count += 1
}

draw :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.BLACK)

	rl.BeginMode2D(game_camera(state.player_position))
	rl.DrawRectangleV(state.player_position, {10, 20}, rl.WHITE)
	rl.DrawRectangleV({20, 20}, {10, 10}, rl.RED)
	rl.DrawRectangleV({-30, -20}, {10, 10}, rl.GREEN)
	rl.EndMode2D()

	rl.BeginMode2D(ui_camera())
	rl.DrawText(
		fmt.ctprintf(
			"Step count: %v\nPlayer position: %v",
			state.step_count,
			state.player_position,
		),
		5,
		5,
		8,
		rl.WHITE,
	)
	rl.EndMode2D()
}

@(export)
init :: proc() {
	state = new(State)
	state^ = State {
		player_position = {0, 0},
	}
	load(state)
}

@(export)
load :: proc(mem: rawptr) {
	state = (^State)(mem)
	log.debugf("New state: %v", state^)
}

@(export)
clear :: proc() {
	log.debug("Clearing state")
	free(state)
}

@(export)
destroy :: proc() {
	log.debug("Cleaning up game")
	clear()
	rl.CloseWindow()
}

@(export)
force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
force_reset :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
