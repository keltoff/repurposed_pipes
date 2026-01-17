extends Node2D

signal paused
signal unpaused
signal reset

var game_paused: bool = false
var game_ended: bool = false

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

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause_game()

func _on_new_block_overflowed() -> void:
	game_ended = true
	paused.emit()
	$GameOverOverlay.show()
	$GameOverOverlay/PanelContainer/ScoreLabel.text = 'Final score: {0}\n\n'.format([$Score/LabelScore.value])

func restart_game() -> void:
	game_ended = false
	game_paused = false
	for overlay in get_tree().get_nodes_in_group("Overlays"):
		overlay.hide()
	reset.emit()

func _on_restart_button_pressed() -> void:
	restart_game()

func _on_pause_credits_button_pressed() -> void:
	pause_game()
