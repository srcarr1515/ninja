extends KinematicBody2D
class_name Player

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
onready var skill_controller = $SkillController

var first_touch
var target_position
var velocity:Vector2
var move_direction
var last_known_dir = "Down"

export (PackedScene) var alt_atk
export var alt_atk_range := 150
export var max_trap_ct := 3
export var speed:= 500
export var dash_speed = 500
export var walk_speed = 150
export var friction:= 0.01
export var acceleration:= 0.1

var input_dir
var touch_distance
var is_swipe = false
var is_in_touch = false

var taps = 0

signal on_move(subject)

func _ready():
	weapon_sprite.visible = false
	skill_controller.subject = self

func _input(event):
	if GameData.game_state != "InGame":
		return
	if event is InputEventMouse:
		if event.is_action_pressed("right_click"):
			alt_attack(get_global_mouse_position())
	if event is InputEventScreenDrag:
		if "position" in event && first_touch:
			touch_distance = abs(event.position.distance_to(first_touch))
			var alpha = clamp(((tap_timer.wait_time - tap_timer.time_left)/tap_timer.wait_time)/2, 0, 0.5)
			if alpha > 0.25:
				taps = 0
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
			if (!touch_distance || touch_distance < 10) && taps > 0:
				alt_attack(get_canvas_transform().affine_inverse().xform(event.position))
			is_swipe = !tap_timer.is_stopped()
			GameData.joystick.visible = false
			is_in_touch = false
			taps += 1

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
#		var turret = load("res://scenes/constructs/Turret.tscn").instance()
#		GameData.level_map.get_node("map/floor").add_child(turret) 
#		turret.target_group = "enemies"
#		turret.global_position = target_position
#		alt_attack_cd.start()
		
#		var trap = load("res://scenes/constructs/BearTrap.tscn").instance()
#		GameData.level_map.get_node("map/floor").add_child(trap) 
#		trap.global_position = target_position
#		alt_attack_cd.start()
		
#		var alt_atk_instance = alt_atk.instance()
#		alt_atk_instance.global_position = global_position
#		if abs(global_position.distance_to(target_position)) < 64:
#			var enemy = nearest_active_enemy()
#			if enemy:
#				target_position = enemy.global_position
#		if (abs(target_position.distance_to(global_position)) <= alt_atk_range):
#			get_tree().get_root().add_child(alt_atk_instance)
#			var direction_toward_enemy = alt_atk_instance.global_position.direction_to(target_position).normalized()
#			alt_atk_instance.direction = direction_toward_enemy
#			alt_attack_cd.start()
		var trap_list = get_tree().get_nodes_in_group("traps")
		var player_traps = []
		for trap in trap_list:
			if trap.is_in_group("player"):
				if trap.fsm.state.name != "Dead":
					player_traps.push_back(trap)
		if player_traps.size() >= max_trap_ct:
			player_traps.front().fsm.change_to("Dead")
		var alt_atk_instance = load("res://scenes/effects/ThrowConstruct.tscn").instance()
		var turret = load("res://scenes/constructs/Turret.tscn").instance()
		alt_atk_instance.spawn_node = GameData.level_map.get_node("map/floor")
		turret.target_group = "enemies"
		alt_atk_instance.boom_instance = turret
		alt_atk_instance.global_position = global_position
		GameData.level_map.get_node("map/floor").add_child(alt_atk_instance)
		var direction_toward_enemy = alt_atk_instance.global_position.direction_to(target_position).normalized()
		alt_atk_instance.direction = direction_toward_enemy
		alt_attack_cd.start()

func _process(delta):
	if !alt_attack_cd.is_stopped():
		GameData.trap_cd_label.text = "Cooling Down: {cd}".format({"cd": alt_attack_cd.time_left})

func _physics_process(delta):
	if fsm.state.name == "Dead":
		return
	input_dir = GameData.joystick.get_node("Joystick_Button").get_value()
	var dir = get_direction_name(input_dir)
	if dir:
		last_known_dir = dir
	var move_speed = 1
	if touch_distance:
		move_speed = clamp((touch_distance/200) * 10, 1, 12)
	if input_dir && dash_cd.is_stopped():
		if is_swipe:
			fsm.change_to("Dash")
		else:
			move_speed = clamp(move_speed, 1, 3)
			velocity = position.direction_to(position + input_dir) * (move_speed * 50)
			if fsm.state.name == "Dash":
				yield(anim_player, "animation_finished")
			fsm.change_to("Walk")
			move_and_slide(velocity)
			emit_signal("on_move", self)
	else:
		yield(anim_player, "animation_finished")
		fsm.change_to("Idle")

func _on_HurtBox_is_dead():
	fsm.change_to("Dead")

func _on_HurtBox_took_damage(amount, attacker):
	GameData.hp_label.text = "HP: {hp}".format({"hp": hurtbox.hp})

func _on_TapTimer_timeout():
	taps = 0

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
	set_animation_from_state_name(_state.name)
#	var state_name = _state.name
#	if ["Dash", "AltAct"].has(_state.name):
#		state_name = "Attack"
#	var animation = "{state}_{dir}".format({"state": state_name, "dir": get_direction_name(input_dir)})
#	if _state.name == "Idle":
#		var prev_anim = anim_player.current_animation.split("_")
#		if prev_anim.size() > 1:
#			anim_player.play("Idle_{dir}".format({"dir": prev_anim[1]}) )
#	elif anim_player.has_animation(animation):
#		anim_player.play(animation)
#	elif anim_player.has_animation(_state.name):
#		anim_player.play(_state.name)

func set_animation_from_state_name(_state_name):
	var state_name = _state_name
	if ["Dash", "AltAct"].has(_state_name):
		state_name = "Attack"
	var animation = "{state}_{dir}".format({"state": state_name, "dir": get_direction_name(input_dir)})
	if _state_name == "Idle":
		var prev_anim = anim_player.current_animation.split("_")
		if prev_anim.size() > 1:
			anim_player.play("Idle_{dir}".format({"dir": prev_anim[1]}) )
	elif anim_player.has_animation(animation):
		anim_player.play(animation)
	elif anim_player.has_animation(_state_name):
		anim_player.play(_state_name)


func _on_AltAttackCD_timeout():
	GameData.trap_cd_label.text = "Trap Ready"

#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name != fsm.state.name:
#		print(fsm.state.name)
#		set_animation_from_state_name(fsm.state.name)

func _on_DashCD_timeout():
	pass
	## TODO: Find a better way to do this
#	velocity = Vector2.ZERO
