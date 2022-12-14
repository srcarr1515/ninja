extends KinematicBody2D

onready var tap_timer := $TapTimer
onready var dash_cd := $DashCD ## Cooldown for Dash Attack
onready var alt_attack_ct := $AltAttackCT ## Charge Time for Alt Attack
onready var alt_attack_cd := $AltAttackCD ## Cooldown for Alt Attack
onready var fsm := $StateMachine
onready var anim_player := $AnimationPlayer
onready var hitbox := $HitBox
onready var detectbox := $DetectBox
onready var hurtbox := $HurtBox
onready var weapon_sprite = $Weapon

var first_touch
var target_position
var velocity:Vector2
var move_direction

export (PackedScene) var alt_atk
export var alt_atk_range := 150
export var speed:= 500
export var dash_speed = 500
export var walk_speed = 150
export var friction:= 0.01
export var acceleration:= 0.1

var input_dir
var touch_distance
var is_swipe = false
var is_in_touch = false

func _ready():
	weapon_sprite.visible = false

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
			if !touch_distance || touch_distance < 5:
				alt_attack(get_canvas_transform().affine_inverse().xform(event.position))
			is_swipe = !tap_timer.is_stopped()
			GameData.joystick.visible = false
			is_in_touch = false

func nearest_active_enemy():
	var targets = get_tree().get_nodes_in_group("enemies")
	var nearest_target = targets.front()
	if nearest_target:
		for t in targets:
			if t.fsm.state.name == "Dead":
				continue
			if t.global_position.distance_to(global_position) < nearest_target.global_position.distance_to(global_position):
				nearest_target = t
	if nearest_target && nearest_target.fsm.state.name == "Dead":
		return null
	return nearest_target

func alt_attack(target_position):
	if alt_attack_cd.is_stopped():
		var alt_atk_instance = alt_atk.instance()
		alt_atk_instance.global_position = global_position
#		var enemy = nearest_active_enemy()
#		if enemy:
#			target_position = enemy.global_position
		if (abs(target_position.distance_to(global_position)) <= alt_atk_range):
			get_tree().get_root().add_child(alt_atk_instance)
			var direction_toward_enemy = alt_atk_instance.global_position.direction_to(target_position).normalized()
			alt_atk_instance.direction = direction_toward_enemy
			alt_attack_cd.start()

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
			if fsm.state.name == "Dash":
				yield(anim_player, "animation_finished")
			fsm.change_to("Walk")
			move_and_slide(velocity)
	else:
		yield(anim_player, "animation_finished")
		fsm.change_to("Idle")

func _on_HurtBox_is_dead():
	fsm.change_to("Dead")

func _on_HurtBox_took_damage(amount):
	GameData.hp_label.text = "HP: {hp}".format({"hp": hurtbox.hp})

func _on_TapTimer_timeout():
	pass

func get_direction_name(direction):
	var dir_name = ""
	if direction:
		var dir_angle = Vector2.ZERO.angle_to_point(direction)
		if dir_angle > 0.8 && dir_angle < 2.2:
			dir_name = "Up"
		elif dir_angle > -0.56 && dir_angle < 0.8:
			dir_name = "Left"
		elif dir_angle > -2.15 && dir_angle < -0.55:
			dir_name = "Down"
		else:
			dir_name = "Right"
	return dir_name

func _on_StateMachine_on_change_state(_state):
	var state_name = _state.name
	if ["Dash", "AltAct"].has(_state.name):
		state_name = "Attack"
	var animation = "{state}_{dir}".format({"state": state_name, "dir": get_direction_name(input_dir)})
	if _state.name == "Idle":
		var prev_anim = anim_player.current_animation.split("_")
		if prev_anim.size() > 1:
			anim_player.play("Idle_{dir}".format({"dir": prev_anim[1]}) )
	elif anim_player.has_animation(animation):
		anim_player.play(animation)
	elif anim_player.has_animation(_state.name):
		anim_player.play(_state.name)
