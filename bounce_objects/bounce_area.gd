extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		if get_parent().has_method("take_damage"):
			get_parent().take_damage(body)
