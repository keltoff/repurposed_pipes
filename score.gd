extends NinePatchRect

func reset():
	$LabelScore.value = 0
	$LabelMulti.value = 1
	$LabelLatest.value = 0
	
func add_points(raw_points: int):
	var points = $LabelMulti.value * raw_points
	$LabelLatest.value = points
	$LabelScore.value += points
	$LabelMulti.value = max($LabelMulti.value -1, 1)

func _on_lines_removed(count: int) -> void:
	print('Removed lines ', count)
	add_points(count * count)

func _on_water_reached_goal() -> void:
	$LabelMulti.value += 5

func _on_game_reset() -> void:
	reset()
