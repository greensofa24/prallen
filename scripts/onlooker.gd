extends Area2D

var radius = 128
var speed = 2

@onready var player = $"../Player"
@onready var current_angle = player.global_position.angle_to_point(global_position)

func _physics_process(delta: float) -> void:
	current_angle += speed * delta

	var offset = Vector2(cos(current_angle), sin(current_angle)) * radius
	global_position = lerp(position, player.global_position + offset, 0.05)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.shooting:
			queue_free()
		else:
			if body.shield:
				body.set_shield(false)
				body.set_shoot_ability(true)
				body.set_charge(5)
			else:
				get_tree().reload_current_scene.call_deferred()
