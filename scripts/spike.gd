extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !body.shield or body.is_colliding():
			get_tree().reload_current_scene.call_deferred()
		else:
			body.set_shield(false)
			body.set_shoot_ability(true)
			body.set_charge(5)
