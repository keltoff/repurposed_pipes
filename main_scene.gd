extends Node2D

signal paused
signal unpaused

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
	# TODO
	pass # Replace with function body.


func _on_tiles_water_reached_goal() -> void:
	goals_reached += 1
	if goals_reached == goals_to_win:
		paused.emit()
		$VictoryOverlay.show()
