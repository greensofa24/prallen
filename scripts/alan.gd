extends Area2D

signal dialogue

var has_dialogue = false
var can_interact = true

@onready var prompt = $Sprite2D
@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	if owner:
		dialogue.connect(owner.play_dialogue)

func enable_dialogue():
	prompt.visible = true
	has_dialogue = true

func close_prompt():
	prompt.modulate.a = 0.5
	can_interact = false
	set_deferred("can_interact", true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and has_dialogue and can_interact:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				dialogue.emit()

func _on_timer_timeout() -> void:
	animation.play("shifty")
