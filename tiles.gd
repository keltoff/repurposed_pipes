extends TileMapLayer

signal lines_removed

var ID_EMPTY = 0
var ID_WATER = 1
var COORDS_NOTHING = Vector2i(-1, -1)

var x_range = range(-6, 7)

var boom_line = load("res://boom_line.tscn")

func is_tile_free(loc: Vector2i):
	return get_cell_atlas_coords(loc) == COORDS_NOTHING
	
func has_water(loc: Vector2i):
	return get_cell_source_id(loc) == ID_WATER

func process_water():
	var new_flooded = []
	
	if $WaterSource:
		var origin = local_to_map($WaterSource.position)
		new_flooded.append(origin)
	
	for cell in get_used_cells_by_id(ID_EMPTY):
		if any_neighbor_filled(cell):
			new_flooded.append(cell)
	
	for cell in new_flooded:
		set_water(cell, true)

func set_water(loc: Vector2i, filled=true):
	var pipe_shape = get_cell_atlas_coords(loc)
	set_cell(loc,  ID_WATER if filled else ID_EMPTY, pipe_shape)

func any_neighbor_filled(loc):
	for neighbor_dir in [Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.UP]:
		var neighbor = loc + neighbor_dir
		if has_water(neighbor) and has_connection(loc, neighbor_dir) and has_connection(neighbor, -neighbor_dir):
			return true
	
	return false

func has_connection(loc: Vector2i, dir: Vector2i):
	var shape = get_cell_atlas_coords(loc)
	match dir:
		Vector2i.RIGHT:
			return shape.x & 1
		Vector2i.DOWN:
			return shape.x & 2
		Vector2i.LEFT:
			return shape.y & 1
		Vector2i.UP:
			return shape.y & 2

func _on_timer_timeout() -> void:
	process_water()

func check_for_line_removed(lines: Array):
	lines.sort()
	
	var removed = 0
	
	for y in lines:
		if is_line_full(y):
			remove_line(y)
			line_flash_effect(y)
			removed += 1
	
	if removed > 0:
		lines_removed.emit(removed)
		
func is_line_full(y: int):
	for x in x_range:
		if is_tile_free(Vector2i(x, y)):
			return false
	
	return true

func remove_line(y0: int):
	for y in range(y0, 0, -1):
		for x in x_range:
			var loc = Vector2i(x, y-1)
			var id = get_cell_source_id(loc)
			var shape = get_cell_atlas_coords(loc)
			set_cell(Vector2i(x, y), id, shape)

func line_flash_effect(line: int):
	var flash = boom_line.instantiate()
	flash.position = map_to_local(Vector2i(0, line))
	add_child(flash)
	
