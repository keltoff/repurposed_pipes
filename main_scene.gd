extends Node2D

signal paused
signal unpaused
signal reset

var game_paused: bool = false
var goals_reached: int = 0
var goals_to_win: int = 1 # TODO: selectable difficulty

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		game_paused = not game_paused
		if game_paused:
			paused.emit()
			$PauseOverlay.show()
		else:
			unpaused.emit()
			$PauseOverlay.hide()


func _on_new_block_overflowed() -> void:
	paused.emit()
	$GameOverOverlay.show()

func _on_restart_button_pressed() -> void:
	goals_reached = 0
	game_paused = false
	for overlay in get_tree().get_nodes_in_group("Overlays"):
		overlay.hide()
	reset.emit()

func _on_tiles_water_reached_goal() -> void:
	goals_reached += 1
	if goals_reached == goals_to_win:
		paused.emit()
		$VictoryOverlay.show()
