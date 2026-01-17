extends Node

@export var moved_left_snd: AudioStream
@export var moved_right_snd: AudioStream
@export var moved_down_snd: AudioStream
@export var rotated_snd: AudioStream
@export var landed_snd: AudioStream
@export var volume_db: float = 0.0

var sfx_players: Array[AudioStreamPlayer]

func _ready() -> void:
	sfx_players.assign(find_children("SFXPlayer?", "AudioStreamPlayer"))

func play(stream: AudioStream, volume_db_adjustment: float = 0.0) -> void:
	var least_recent = sfx_players.pop_front()
	least_recent.stream = stream
	least_recent.volume_db = self.volume_db + volume_db_adjustment
	least_recent.play()
	sfx_players.push_back(least_recent)

func _on_new_block_block_landed() -> void:
	self.play(landed_snd)

func _on_new_block_block_rotated() -> void:
	self.play(rotated_snd)

func _on_new_block_block_moved_down() -> void:
	self.play(moved_down_snd)

func _on_new_block_block_moved_left() -> void:
	self.play(moved_left_snd)

func _on_new_block_block_moved_right() -> void:
	self.play(moved_right_snd)

func _on_sfx_slider_value_changed(value: float) -> void:
	if value == %SFXSlider.min_value:
		volume_db = -INF
	else:
		volume_db = value
