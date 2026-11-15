extends Panel

signal play_dialogue

var talk_sprite = "res://sprites/alan.png"
var frame = 2

var current_dialogue
var progress
var skipped

var frames_passed = 0
var stopped = false

@onready var root = get_tree().current_scene

@onready var timer = $Timer
@onready var sprite = $Sprite2D
@onready var label = $RichTextLabel
@onready var audio_player = $AudioStreamPlayer2D

func _ready() -> void:
	if root:
		play_dialogue.connect(root.play_dialogue)

func play(dialogue) -> void:
	frame = 2

	label.text = dialogue
	current_dialogue = dialogue
	progress = 0
	skipped = false

	frames_passed = 0
	stopped = false

	timer.wait_time = 0.05
	timer.start()

	sprite.texture = load(talk_sprite)
	
	sprite.hframes = 2
	sprite.vframes = 2
	
	sprite.frame = frame

func _on_timer_timeout() -> void:
	if !stopped:
		next_char()

	frames_passed += 1
	if frames_passed % 3 == 0:
		frame = 5 - frame
		sprite.frame = frame

	if stopped and frame == 2:
		timer.stop()

func next_char():
	if skipped: stopped = true

	progress += 1
	label.visible_characters = progress

	var plain_text = label.get_parsed_text()

	if progress < plain_text.length():
		if plain_text[progress] != " ":
			audio_player.play()

	if progress < plain_text.length():
		var next_space = plain_text.find(" ", progress)
		if next_space == -1:
			next_space = plain_text.length()

		var original_line_count = label.get_character_line(progress - 1)
		var appended_line_count = label.get_character_line(next_space - 1)

		if appended_line_count > original_line_count:
			var raw_index = _get_raw_index_from_visible(current_dialogue, progress - 1)
			var last_space = current_dialogue.rfind(" ", raw_index)

			if last_space != -1:
				current_dialogue[last_space] = "\n"
				label.text = current_dialogue

	if progress == plain_text.length():
		stopped = true

func _get_raw_index_from_visible(bbcode_text: String, visible_index: int) -> int:
	var raw_idx = 0
	var vis_idx = 0
	var in_tag = false
	
	while raw_idx < bbcode_text.length():
		var c = bbcode_text[raw_idx]
		if c == "[":
			in_tag = true
		elif c == "]" and in_tag:
			in_tag = false
		elif not in_tag:
			if vis_idx == visible_index:
				return raw_idx
			vis_idx += 1
		raw_idx += 1
		
	return raw_idx

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and root and root.playing_dialogue and stopped:
		play_dialogue.emit()

	if event.is_action_pressed("ui_cancel") and root and root.playing_dialogue:
		progress = label.get_parsed_text().length()
		skipped = true
