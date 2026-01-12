extends Node2D

const STEP: int = 32
const NEW_BLOCK_ORIGIN_X = STEP * 5
@export var blocks: Array[PackedScene] = []
var current_block: Area2D

signal moved_left
signal moved_right
signal moved_down
signal rotated
signal new_block


func _ready() -> void:
	spawn_random_block()


func _process(delta: float) -> void:
	current_block.
	pass
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left"):
		current_block.position.x -= STEP
		moved_left.emit()
	if Input.is_action_just_pressed("Right"):
		current_block.position.x += STEP
		moved_right.emit()
	if Input.is_action_just_pressed("Drop"):
		current_block.position.y += STEP
		moved_down.emit()
	if Input.is_action_just_pressed("Rotate"):
		rotated.emit()
		pass # not yet implemented

func _on_timer_timeout() -> void:
	current_block.position.y += STEP
	moved_down.emit()
	
	if piece_on_ground():
		# delete it, fill respective grid cells
		# Then, create new NewBlock
		
		# But for now ...
		#current_block.position = Vector2(0, 0)
		current_block.queue_free()
		spawn_random_block()
		new_block.emit()
		

func spawn_random_block():
	current_block = blocks.pick_random().instantiate()
	add_child(current_block)
	current_block.position.x = NEW_BLOCK_ORIGIN_X
	pass

func piece_on_ground():
	return current_block.position.y > 500
