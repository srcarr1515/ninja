extends KinematicBody2D

onready var tap_timer := $TapTimer
onready var dash_cd := $DashCD ## Cooldown for Dash Attack
onready var alt_attack_ct := $AltAttackCT ## Charge Time for Alt Attack
onready var fsm := $StateMachine
onready var anim_player := $AnimationPlayer
onready var hitbox := $HitBox
onready var detectbox := $DetectBox
onready var hurtbox := $HurtBox

var first_touch
var target_position
var velocity:Vector2
var move_direction

export var speed:= 500
export var dash_speed = 500
export var walk_speed = 150
export var friction:= 0.01
export var acceleration:= 0.1

var new_angle
var in_touch = false
var input_dir
var is_dragging = false

func _input(event):
	is_dragging = event is InputEventScreenDrag
	if event is InputEventScreenTouch:
		if event.is_pressed():
			GameData.joystick.visible = false
			in_touch = true
			first_touch = event.position
			GameData.joystick.position = event.position
			tap_timer.start()
			alt_attack_ct.start()
		elif !event.is_pressed():
			if abs(event.position.distance_to(first_touch)) <= 50 && !tap_timer.is_stopped():
				speed = walk_speed
				first_touch = null
				target_position = get_canvas_transform().xform_inv(event.position)
				fsm.change_to('Walk')
			elif !GameData.joystick.visible && dash_cd.is_stopped():
				dash_cd.start()
				speed = dash_speed
				new_angle = event.position.angle_to_point(first_touch)
				target_position = get_end_pos_from_start_pos_and_angle(position, new_angle, 96)
				fsm.change_to('Dash')
			in_touch = false
			GameData.joystick.visible = false

func _process(delta):
	if in_touch && alt_attack_ct.is_stopped() && !is_dragging:
		GameData.joystick.visible = true

func get_end_pos_from_start_pos_and_angle(start_pos, angle, distance):
	var x = start_pos.x + (distance * cos(angle))
	var y = start_pos.y + (distance * sin(angle))
	return Vector2(x, y)

func get_collision_side(collision_pos):
	var x = collision_pos.x - position.x
	var y = collision_pos.y - position.y
	var side
	if abs(x) > 1:
		## LEFT/RIGHT
		if x > 0:
			side = "RIGHT"
		else:
			side = "LEFT"
	else:
		## UP/DOWN
		if y > 0:
			side = "DOWN"
		else:
			side = "UP"
	return side

func _physics_process(delta):
	if target_position:
		velocity = position.direction_to(target_position) * speed
		move_direction = rad2deg(target_position.angle_to_point(position))
		if position.distance_to(target_position) >= 5:
			velocity = move_and_slide(velocity)
		else:
			velocity = Vector2.ZERO
			fsm.change_to("Idle")
	elif in_touch && !target_position:
		input_dir = GameData.joystick.get_node("Joystick_Button").get_value()
