extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_side():
	self.stream = AudioStreamWAV.load_from_file("snd/move.wav")
	self.play()


func _on_block_handler_moved_down() -> void:
	self.stream = AudioStreamWAV.load_from_file("snd/drop.wav")
	self.play()


func _on_block_handler_moved_left() -> void:
	move_side()


func _on_block_handler_moved_right() -> void:
	move_side()


func _on_block_handler_rotated() -> void:
	pass # Replace with function body.


func _on_block_handler_new_block() -> void:
	self.stream = AudioStreamWAV.load_from_file("snd/reset.wav")
	self.play()
