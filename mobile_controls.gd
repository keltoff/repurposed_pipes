## NOTE: This whole thing is a workaround: on my Andriod, TouchScreenButton sends eevery event twice
extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# show only on mobile platforms
	if OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
		show()
	else:
		hide()

func inject_action(pressed: bool, action: String):
	var ev = InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	Input.parse_input_event(ev)

func _on_left_button_button_down() -> void:
	inject_action(true, "Left")

func _on_left_button_button_up() -> void:
	inject_action(false, "Left")

func _on_down_button_button_up() -> void:
	inject_action(true, "Drop")

func _on_down_button_button_down() -> void:
	inject_action(false, "Drop")

func _on_rotate_button_button_down() -> void:
	inject_action(true, "Rotate")

func _on_rotate_button_button_up() -> void:
	inject_action(false, "Rotate")

func _on_right_button_button_down() -> void:
	inject_action(true, "Right")

func _on_right_button_button_up() -> void:
	inject_action(false, "Right")
