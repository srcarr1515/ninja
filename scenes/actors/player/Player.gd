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

var input_dir
var touch_distance
var is_swipe = false
var is_in_touch = false

func _input(event):
	if event is InputEventScreenDrag:
		if "position" in event && first_touch:
			touch_distance = event.position.distance_to(first_touch)
			var alpha = clamp(((tap_timer.wait_time - tap_timer.time_left)/tap_timer.wait_time)/2, 0, 0.5)
			if alpha > 0.25:
				GameData.joystick.set_modulate(Color(1,1,1,alpha - 0.1))
	if event is InputEventScreenTouch:
		if event.is_pressed():
			is_in_touch = true
			is_swipe = false
			tap_timer.start()
			GameData.joystick.visible = true
			GameData.joystick.set_modulate(Color(1,1,1,0))
			GameData.joystick.position = event.position
			first_touch = event.position
		elif !event.is_pressed():
			is_swipe = !tap_timer.is_stopped()
			GameData.joystick.visible = false
			is_in_touch = false

func _physics_process(delta):
	if fsm.state.name == "Dead":
		return
	input_dir = GameData.joystick.get_node("Joystick_Button").get_value()
	var move_speed = 1
	if touch_distance:
		move_speed = clamp((touch_distance/200) * 10, 1, 12)
	if input_dir:
		if is_swipe:
			velocity = position.direction_to(position + input_dir) * 15
			var collision = move_and_collide(velocity)
			fsm.change_to("Dash")
		else:
			move_speed = clamp(move_speed, 1, 3)
			velocity = position.direction_to(position + input_dir) * (move_speed * 50)
			fsm.change_to("Walk")
			move_and_slide(velocity)
	else:
		fsm.change_to("Idle")

func _on_HurtBox_is_dead():
	fsm.change_to("Dead")

func _on_HurtBox_took_damage(amount):
	GameData.hp_label.text = "HP: {hp}".format({"hp": hurtbox.hp})

func _on_TapTimer_timeout():
	pass
