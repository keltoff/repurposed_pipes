extends Timer

func _on_game_paused() -> void:
	self.paused = true

func _on_game_unpaused() -> void:
	self.paused = false
