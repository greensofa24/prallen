extends RigidBody2D

signal update_charge_bar
signal update_shield

var roll_speed = 1500.0
var shoot_strength = 4000.0
var brake_strength = 0.9
var v_speed_limit = 1000.0
var h_speed_limit = 1500.0

var can_shoot = false
var charge = 5
var shooting = false

var shield = true
var was_on_floor = false

@onready var sprite = $Sprite2D
@onready var charge_timer = $ChargeTimer
@onready var shoot_timer = $ShootTimer

func _ready() -> void:
	add_to_group("player")

	if owner:
		update_charge_bar.connect(owner.update_charge_bar)
		update_shield.connect(owner.update_shield)

func is_colliding() -> bool:
	return test_move(global_transform, Vector2.ZERO, null, 0.08, true)

func shared_shot_code():
	set_charge(0)
	set_shoot_ability(false)
	shooting = true
	shoot_timer.start()
	sprite.material.set_shader_parameter("shooting", true)

func _physics_process(delta: float) -> void:
	if is_colliding():
		set_shoot_ability(true)
		set_shield(false)

	if was_on_floor and !is_colliding():
		set_shield(true)

	was_on_floor = is_colliding()

	if Input.is_action_pressed("ui_right"):
		apply_torque_impulse(roll_speed * delta)
		if !is_colliding():
			apply_central_force(Vector2(roll_speed * delta, 0))

	if Input.is_action_pressed("ui_left"):
		apply_torque_impulse(-roll_speed * delta)
		if !is_colliding():
			apply_central_force(Vector2(-roll_speed * delta, 0))

	if Input.is_action_just_pressed("ui_accept") and charge == 5:
		var dir = Vector2(0, 0)

		if can_shoot:
			if Input.is_action_pressed("ui_left"):
				dir.x = -1
				shared_shot_code()
			if Input.is_action_pressed("ui_right"):
				dir.x = 1
				shared_shot_code()
			if Input.is_action_pressed("ui_up"):
				dir.y = -1
				shared_shot_code()

		if Input.is_action_pressed("ui_down"):
			dir.y = 1
			shared_shot_code()

		dir.x /= 2
		apply_central_force(dir * shoot_strength)

	if Input.is_action_pressed("ui_cancel"):
		linear_velocity.x *= brake_strength

	if abs(linear_velocity.x) < 10 and !(Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		sprite.frame = 0
		rotation = lerp_angle(rotation, 0.0, 0.1)
	else:
		sprite.frame = 2

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if abs(state.linear_velocity.x) > h_speed_limit:
		state.linear_velocity.x = h_speed_limit * sign(state.linear_velocity.x)

	if abs(state.linear_velocity.y) > v_speed_limit:
		state.linear_velocity.y = v_speed_limit * sign(state.linear_velocity.y)

func set_charge(value):
	charge = value
	update_charge_bar.emit()
	if charge < 5:
		charge_timer.start()
	else:
		charge_timer.stop()

func set_shoot_ability(value):
	can_shoot = value
	update_charge_bar.emit()

func set_shield(value):
	shield = value
	update_shield.emit(value)

func _on_charge_timer_timeout() -> void:
	set_charge(charge + 1)

func _on_shoot_timer_timeout() -> void:
	shooting = false
	sprite.material.set_shader_parameter("shooting", false)
