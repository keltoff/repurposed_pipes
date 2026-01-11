extends Node2D

var STEP: int = 32

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left"):
		$NewBlock.position.x -= STEP
	if Input.is_action_just_pressed("Right"):
		$NewBlock.position.x += STEP
	if Input.is_action_just_pressed("Drop"):
		$NewBlock.position.y += STEP
	if Input.is_action_just_pressed("Rotate"):
		pass # not yet implemented

func _on_timer_timeout() -> void:
	$NewBlock.position.y += STEP
	
	if piece_on_ground():
		# delete it, fill respective grid cells
		# Then, create new NewBlock
		
		# But for now ...
		$NewBlock.position = Vector2(0, 0)

func spawn_piece():
	pass

func piece_on_ground():
	return $NewBlock.position.y > 500
