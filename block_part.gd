@tool

extends Sprite2D
class_name BlockPart

@export
var atlas_coordinates: Vector2i

func _create() -> void:
	texture = AtlasTexture.new()
	texture.atlas = load("res://img/pipes_atlas.tres")
	texture.region.size = Vector2i(32, 32)
	texture.region.position = Vector2i(0, 0)

func set_coordinates(coords: Vector2i):
	atlas_coordinates = coords
	texture.region.position = 32 * coords

func is_free():
	return is_tile_free(my_pos_in_tiles())

func can_move(dir: Vector2i):
	var new_loc = my_pos_in_tiles() + dir
	return is_tile_free(new_loc)

func write_to_tiles():
	var loc = my_pos_in_tiles()
	
	%Tiles.set_cell(loc, 0, apply_rotation(atlas_coordinates))
	#%Tiles.set_cell(loc, 0, atlas_coordinates)

func apply_rotation(atlas_coords: Vector2i) -> Vector2i:
	var turns = (roundi(self.global_rotation_degrees / 90) + 4) % 4
	var tile_code = atlas_coords.y * 4 + atlas_coords.x

	# bit rotation
	var turned_code = 15 & (tile_code << turns) | (tile_code >> (4 - turns))
	return Vector2i(turned_code & 3, turned_code >> 2)

func my_pos_in_tiles():
	return %Tiles.local_to_map(%Tiles.to_local(global_position))

# TODO move to Tiles
func is_tile_free(loc: Vector2i):
	return %Tiles.get_cell_atlas_coords(loc) == Vector2i(-1, -1)
