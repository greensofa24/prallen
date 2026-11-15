extends Area2D

var win_sound = preload("res://sounds/win.wav")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		AudioController.change_sound(win_sound)
		AudioController.play_sound()

		var current_path = get_tree().current_scene.scene_file_path.replace(".tscn", "")

		var next_level_id
		if current_path[-1].is_valid_int():
			next_level_id = current_path.to_int() + 1

		var next_level_path = "res://scenes/levels/level " + str(next_level_id) + ".tscn"
		get_tree().change_scene_to_file.call_deferred(next_level_path)
