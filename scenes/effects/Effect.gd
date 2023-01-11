extends KinematicBody2D

export (String, "static", "on_player") var movement_type = "static"
export var animation_on_start := ""

## Player Options
export (String) var player_animation

## Timer Options
export var timer_wait_time:= 0.5
export var timer_autostart:= false
onready var timer = $Timer

export (String, "on_time_out_start", "on_time_out_end") var destroy_on_timeout
export var destroy_on_animation_finished = ""

## Size/Scale Options
export (Array, Vector2) var randomize_scale ## randomly pick from this list.

## Dash Options
export (String, "bullet") var player_movement_type
export (int) var dash_speed

## Spawn Options
export (Array, PackedScene) var spawn_list
export (Array, int) var spawn_rotation
export (String, "custom_vector", "nearest_enemy") var spawn_position_type
export (Vector2) var spawn_pos_custom_vector
export (String, "on_ready", "on_timeout") var when_to_spawn = "on_ready"
export (int) var spawn_atk_power

## Misc Options
export (int) var effect_radius
export (String, "player", "enemies") var target_group = "enemies"
export (String, "player", "enemy") var user_type = "player"


onready var anim_player = $AnimationPlayer
onready var hitbox = $HitBox

func _ready():
	if timer_autostart:
		timer.start(timer_wait_time)
	if animation_on_start != "":
		if anim_player.has_animation(animation_on_start):
			anim_player.play(animation_on_start)
	
	var user_group = {
		"player": "player",
		"enemy": "enemies"
	}
	add_to_group(user_group[user_type])
	hitbox.get_node("Area").set_collision_mask_bit(1, target_group == "player")
	hitbox.get_node("Area").set_collision_mask_bit(2, target_group == "enemies")
	
	if randomize_scale.size() > 0:
		set_scale(Helpers.choose(randomize_scale))
	spawn()

func spawn():
	if spawn_list.size() > 0:
		for s in spawn_list.size():
			var spawn = spawn_list[s].instance()
			var spawn_position

			if spawn_position_type:
				spawn_position = get_spawn_position()
			else:
				spawn_position = global_position
			
			if spawn_position != null:
				add_child(spawn)
				spawn.global_position = spawn_position
			if s <= spawn_rotation.size() - 1:
				spawn.rotation_degrees = spawn_rotation[s]
			if spawn_atk_power:
				spawn.get_node("HitBox").attack_power = spawn_atk_power
			if spawn is Orbiter:
				spawn.is_orbiting = true

func get_spawn_position():
	if spawn_position_type == "custom_vector":
		return spawn_pos_custom_vector
	elif spawn_position_type == "nearest_enemy":
		var target_enemy = Helpers.pick_nearest("enemies", global_position, "corpses")
		if !target_enemy:
			return
		if effect_radius:
			print(abs(global_position.distance_to(target_enemy.global_position)))
			if effect_radius >= abs(global_position.distance_to(target_enemy.global_position)):
				return target_enemy.global_position
		else:
			return target_enemy.global_position

func _physics_process(delta):
	if movement_type == "on_player":
		global_position = GameData.player.global_position

func _on_Timer_timeout():
	if when_to_spawn == "on_timeout":
		spawn()
	if destroy_on_timeout == "on_time_out_start":
		call_deferred("queue_free")
	
	if destroy_on_timeout == "on_time_out_end":
		call_deferred("queue_free")

func _on_AnimationPlayer_animation_finished(anim_name):
	if destroy_on_animation_finished == anim_name:
		call_deferred("queue_free")
