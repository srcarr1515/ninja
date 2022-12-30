extends KinematicBody2D

export (String, "static", "on_player") var movement_type = "static"
export var animation_on_start := ""

## Player Options
export (String) var player_animation

## Timer Options
export (String, "on_time_out_start", "on_time_out_end") var destroy_on_timeout

## Size/Scale Options
export (Array, Vector2) var randomize_scale ## randomly pick from this list.

## Dash Options
export (String, "bullet") var player_movement_type
export (int) var dash_speed

onready var anim_player = $AnimationPlayer

func _ready():
	if animation_on_start != "":
		if anim_player.has_animation(animation_on_start):
			anim_player.play(animation_on_start)
	if randomize_scale.size() > 0:
		set_scale(Helpers.choose(randomize_scale))

func _physics_process(delta):
	if movement_type == "on_player":
		global_position = GameData.player.global_position

func _on_Timer_timeout():
	if destroy_on_timeout == "on_time_out_start":
		call_deferred("queue_free")
	
	if destroy_on_timeout == "on_time_out_end":
		call_deferred("queue_free")
