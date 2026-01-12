@tool

extends Sprite2D
class_name BlockPart

@export
var atlas_coordinates: Vector2i:
	get:
		return atlas_coordinates
	set(x):
		atlas_coordinates = x
		texture.region.position = 32 * Vector2(atlas_coordinates)

func _init() -> void:
	texture = AtlasTexture.new()
	texture.atlas = load("res://img/pipes_atlas.tres")
	texture.region.size = Vector2(32, 32)
	#texture.region.position = Vector2(0, 0)
	atlas_coordinates = Vector2i(1, 1)

func is_free():
	return is_tile_free(my_pos_in_tiles())

func can_move(dir: Vector2i):
	var new_loc = my_pos_in_tiles() + dir
	return is_tile_free(new_loc)

func write_to_tiles():
	var loc = my_pos_in_tiles()
	
	%Tiles.set_cell(loc, 0, apply_rotation(atlas_coordinates))

func apply_rotation(atlas_coords: Vector2i) -> Vector2i:
	# a bit of magic here - coordinates are also bite flags for pipe ends
	# x = up, left    y = down, right
	# rotating the piece is done by bit rotation of the tile code
	
	var turns = (roundi(self.global_rotation_degrees / 90) + 4) % 4
	var tile_code = atlas_coords.y * 4 + atlas_coords.x
	var turned_code = 15 & (tile_code << turns) | (tile_code >> (4 - turns))
	return Vector2i(turned_code & 3, turned_code >> 2)

func my_pos_in_tiles():
	return %Tiles.local_to_map(%Tiles.to_local(global_position))

# TODO move to Tiles
func is_tile_free(loc: Vector2i):
	return %Tiles.get_cell_atlas_coords(loc) == Vector2i(-1, -1)
