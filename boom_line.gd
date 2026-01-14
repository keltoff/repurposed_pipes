extends Node2D

func _ready() -> void:
	for child in get_children():
		child.play()

func _on_animation_finished():
	for child in get_children():
		queue_free()
	queue_free()
