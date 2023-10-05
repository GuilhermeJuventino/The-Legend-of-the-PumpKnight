extends Control


func _ready():
	$VBoxContainer/Play.grab_focus()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/level_preset.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://menu/controls.tscn")
