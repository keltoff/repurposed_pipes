extends Node2D

signal block_moved_left
signal block_moved_right
signal block_moved_down
signal block_rotated
signal block_landed

@onready
var tilemap = %Tiles

var grid_position : Vector2i :
	set(x):
		grid_position = x
		global_position = tilemap.to_global(tilemap.map_to_local(grid_position))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left") and can_all_move(Vector2i.LEFT):
		grid_position += Vector2i.LEFT
		block_moved_left.emit()
	if Input.is_action_just_pressed("Right") and can_all_move(Vector2i.RIGHT):
		grid_position += Vector2i.RIGHT
		block_moved_right.emit()
	if Input.is_action_just_pressed("Drop") and can_all_move(Vector2i.DOWN):
		grid_position += Vector2i.DOWN
		block_moved_down.emit()
	if Input.is_action_just_pressed("Rotate"):
		try_rotate()

func _on_timer_timeout() -> void:
	if get_child_count() == 0:
		get_new_piece()
		return

	if can_all_move(Vector2i.DOWN):
		grid_position += Vector2i.DOWN
		block_moved_down.emit()
	else:
		# we hit terrain
		var affected_rows = []
		
		for child in get_children():
			child.write_to_tiles()
			child.queue_free()
			block_landed.emit()
			
			var y = child.my_pos_in_tiles().y
			affected_rows.append(y)
	
		tilemap.check_for_line_removed(affected_rows)
				
func try_rotate():
	var original_rotation = rotation_degrees

	rotation_degrees += 90

	for correction in [Vector2i.ZERO, Vector2i.LEFT, Vector2i.RIGHT]:
		if can_all_move(correction):
			grid_position += correction
			block_rotated.emit()
			return

	rotation_degrees = original_rotation

func get_new_piece():
	var new_piece = %PieceQueue.pop_piece()
	for child in new_piece.get_children():
		child.owner = null
		child.reparent(self, false)

	new_piece.queue_free()

	rotation_degrees = 90.
	grid_position = Vector2i(0, 0)

func can_all_move(dir: Vector2i):
	for child in get_children():
		if not child.can_move(dir):
			return false

	return true

func _on_game_paused() -> void:
	self.set_process_input(false)

func _on_game_unpaused() -> void:
	self.set_process_input(true)
