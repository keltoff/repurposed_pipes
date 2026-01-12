extends Node2D

var grid_position = Vector2i(0, 0)

func _input(_event: InputEvent) -> void:
	global_position = %Tiles.to_global(%Tiles.map_to_local(grid_position))
	
	if Input.is_action_just_pressed("Left") and can_all_move(Vector2i.LEFT):
		grid_position += Vector2i.LEFT
	if Input.is_action_just_pressed("Right") and can_all_move(Vector2i.RIGHT):
		grid_position += Vector2i.RIGHT
	if Input.is_action_just_pressed("Drop") and can_all_move(Vector2i.DOWN):
		grid_position += Vector2i.DOWN
	if Input.is_action_just_pressed("Rotate"):
		rotation_degrees += 90
		#for child in get_children():
			#child.write_to_tiles()
	
	global_position = %Tiles.to_global(%Tiles.map_to_local(grid_position))

func _on_timer_timeout() -> void:
	if can_all_move(Vector2i.DOWN):
		grid_position += Vector2i.DOWN
		global_position = %Tiles.to_global(%Tiles.map_to_local(grid_position))
	else:
		# we hit terrain
		for child in get_children():
			child.write_to_tiles()
		
		# And reset
		grid_position = Vector2i(0, 0)
		global_position = %Tiles.to_global(%Tiles.map_to_local(grid_position))
		rotation = 0.
		# TODO: empty, load new blocks
			

func can_all_move(dir: Vector2i):
	for child in get_children():
		if not child.can_move(dir):
			return false
	
	print()
	return true
