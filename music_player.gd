extends AudioStreamPlayer

@export var songs: Array[AudioStream]
var current_song_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.stream = songs[current_song_idx]
	self.play()

func _on_finished() -> void:
	self.current_song_idx = (current_song_idx + 1) % len(songs)
	self.stream = songs[current_song_idx]
	self.play()
