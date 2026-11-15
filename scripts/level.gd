extends Node2D

@export var dialogue: Array[String]
@export var enemies = false

var progress = 0
var playing_dialogue = false

@onready var canvas_layer = preload("res://scenes/canvas_layer.tscn").instantiate()
@onready var panel = canvas_layer.get_node("Panel")
@onready var charge_bar = canvas_layer.get_node("ChargeBar")
@onready var shield = canvas_layer.get_node("Shield")

@onready var player = $Player
@onready var alan = $Alan

func _ready() -> void:
	add_child(canvas_layer)

	if dialogue:
		alan.enable_dialogue()

func play_dialogue():
	if progress < dialogue.size():
		get_tree().paused = true
		playing_dialogue = true

		panel.visible = true
		panel.play(dialogue[progress])

		panel.next_char()

		progress += 1
	else:
		get_tree().paused = false
		playing_dialogue = false

		panel.visible = false
		alan.close_prompt()

		progress = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_reset"):
		player.sprite.material.set_shader_parameter("shooting", false)
		get_tree().reload_current_scene()

func update_charge_bar():
	charge_bar.material.set_shader_parameter("charge", player.charge)
	charge_bar.material.set_shader_parameter("ability", player.can_shoot)

func update_shield(value):
	shield.frame = 0 if value else 1
