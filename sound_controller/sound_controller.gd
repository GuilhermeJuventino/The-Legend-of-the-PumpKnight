extends Node2D

@onready var level_clear_sound: AudioStreamPlayer = $LevelClearSound


func play():
	level_clear_sound.play()
