extends Node2D

signal paused
signal unpaused
signal reset

var game_paused: bool = false
var game_ended: bool = false
var goals_reached: int = 0
var goals_to_win: int = 1 # TODO: selectable difficulty

func pause_game():
	if not game_ended:
		game_paused = not game_paused
		if game_paused:
			paused.emit()
			$PauseCreditsOverlay.show()
		else:
			unpaused.emit()
			$PauseCreditsOverlay.hide()
	else:
		for overlay in get_tree().get_nodes_in_group("Overlays"):
			overlay.hide()
		$PauseCreditsOverlay.show()
		# don't touch pause - player must restart the game

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause_game()

func _on_new_block_overflowed() -> void:
	game_ended = true
	paused.emit()
	$GameOverOverlay.show()

func restart_game() -> void:
	game_ended = false
	goals_reached = 0
	game_paused = false
	for overlay in get_tree().get_nodes_in_group("Overlays"):
		overlay.hide()
	reset.emit()

func _on_tiles_water_reached_goal() -> void:
	goals_reached += 1
	if goals_reached == goals_to_win:
		game_ended = true
		paused.emit()
		$VictoryOverlay.show()

func _on_restart_easy_button_pressed() -> void:
	goals_to_win = 1
	restart_game()

func _on_restart_normal_button_pressed() -> void:
	goals_to_win = 2
	restart_game()

func _on_pause_credits_button_pressed() -> void:
	pause_game()
