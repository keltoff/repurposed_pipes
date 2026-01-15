extends Node2D

signal paused
signal unpaused

var game_paused: bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		game_paused = not game_paused
		if game_paused:
			paused.emit()
			$PauseOverlay.show()
		else:
			unpaused.emit()
			$PauseOverlay.hide()
