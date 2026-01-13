extends Node2D

@onready
var tilemap = %Tiles

var grid_position : Vector2i :
	set(x):
		grid_position = x
		global_position = tilemap.to_global(tilemap.map_to_local(grid_position))

#func _init() -> void:
	#grid_position = Vector2i(0, 0)

func _input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Left") and can_all_move(Vector2i.LEFT):
		grid_position += Vector2i.LEFT
	if Input.is_action_just_pressed("Right") and can_all_move(Vector2i.RIGHT):
		grid_position += Vector2i.RIGHT
	if Input.is_action_just_pressed("Drop") and can_all_move(Vector2i.DOWN):
		grid_position += Vector2i.DOWN
	if Input.is_action_just_pressed("Rotate"):
		try_rotate()

func _on_timer_timeout() -> void:
	if get_child_count() == 0:
		get_new_piece()
		return
		
	if can_all_move(Vector2i.DOWN):
		grid_position += Vector2i.DOWN
	else:
		# we hit terrain
		for child in get_children():
			child.write_to_tiles()
			child.queue_free()

func try_rotate():
	var original_rotation = rotation_degrees
	
	rotation_degrees += 90
	
	for correction in [Vector2i.ZERO, Vector2i.LEFT, Vector2i.RIGHT]:
		if can_all_move(correction):
			grid_position += correction
			return
	
	rotation_degrees = original_rotation

func get_new_piece():
	var new_piece = %PieceQueue.pop_piece()
	for child in new_piece.get_children():
		child.owner = null
		child.reparent(self, false)
	
	new_piece.queue_free()
	
	rotation = 0.
	grid_position = Vector2i(0, 0)
	
func can_all_move(dir: Vector2i):
	for child in get_children():
		if not child.can_move(dir):
			return false
	
	return true
