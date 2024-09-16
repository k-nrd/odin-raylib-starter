package core

import "core:log"

State :: struct {
	player_position: Vec2,
	step_count:      int,
}

state: ^State

state_init :: proc() {
	state = new(State)
	state^ = State{}
}

state_destroy :: proc() {
	free(state)
	log.debug("State destroyed")
}

state_get :: proc() -> ^State {
	return state
}

state_size :: proc() -> int {
	return size_of(State)
}

state_load :: proc(new_state: rawptr) {
	state = (^State)(new_state)
	log.debugf("Loaded new state: %v", state_get()^)
}

state_set_player_position :: proc()
