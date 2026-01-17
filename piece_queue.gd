extends Node2D


var base_patterns = [
	load("res://pieces/piece_i.tscn"),
	load("res://pieces/piece_l.tscn"),
	load("res://pieces/piece_l2.tscn"),
	load("res://pieces/piece_o.tscn"),
	load("res://pieces/piece_s.tscn"),
	load("res://pieces/piece_s2.tscn"),
	load("res://pieces/piece_t.tscn")
]
var patterns: Array
# this will force a shuffle when the game starts
var next_piece_idx: int = 0

const QUEUE_LENGTH = 5

func _init():
	# # We have a long prediction queue, and lack of repeats is conspicuous
	# patterns = base_patterns.duplicate()
	patterns.append_array(base_patterns)
	patterns.shuffle()	
	for i in range(QUEUE_LENGTH):
		add_piece()

func add_piece():
	if next_piece_idx == len(patterns):
		patterns.shuffle()
		next_piece_idx = 0
	var piece = self.patterns[next_piece_idx].instantiate()
	piece.rotation_degrees = 90
	self.add_child(piece)
	resort_items()
	next_piece_idx += 1

func pop_piece():
	var piece = self.get_child(0)
	self.remove_child(piece)
	add_piece()
	resort_items()
	return piece

func resort_items():
	var step = 100
	var x0 = 0
	
	for child in get_children():
		child.position = Vector2(x0, 0)
		x0 += step


func _on_game_reset() -> void:
	for child in get_children():
		remove_child(child)
	_init()
