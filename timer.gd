extends Timer

func _on_game_paused() -> void:
	self.paused = true

func _on_game_unpaused() -> void:
	self.paused = false

func _on_game_reset() -> void:
	# this will reset the timer... I hope
	self.stop()
	self.start()
	self.paused = false
