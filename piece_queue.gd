extends NinePatchRect

var patterns = [
	load("res://pieces/piece_i.tscn"),
	load("res://pieces/piece_l.tscn"),
	load("res://pieces/piece_l2.tscn"),
	load("res://pieces/piece_o.tscn"),
	load("res://pieces/piece_s.tscn"),
	load("res://pieces/piece_s2.tscn"),
	load("res://pieces/piece_t.tscn")
]

func _init():
	for i in range(6):
		add_random_piece()

func add_random_piece():
	var piece = self.patterns.pick_random().instantiate()
	piece.rotation_degrees = 90
	self.add_child(piece)
	resort_items()

func pop_piece():
	var piece = self.get_child(0)
	self.remove_child(piece)
	add_random_piece()
	resort_items()
	return piece

func resort_items():
	var step = 100
	var x0 = step
	var y = size.y / 2
	
	for child in get_children():
		child.position = Vector2(x0, y)
		x0 += step


func _on_game_reset() -> void:
	for child in get_children():
		remove_child(child)
	_init()
