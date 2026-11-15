extends Area2D

var win_sound = preload("res://sounds/win.wav")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if owner.find_children("*Onlooker*", "", true, false).is_empty():
			AudioController.change_sound(win_sound)
			AudioController.play_sound()

			get_tree().change_scene_to_file.call_deferred("res://scenes/test level.tscn")
