extends Node

@onready var audio_player = $AudioStreamPlayer2D

func play_sound():
	audio_player.play()

func stop_sound():
	audio_player.stop()

func change_sound(stream):
	audio_player.stream = stream
