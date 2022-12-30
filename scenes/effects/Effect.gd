extends KinematicBody2D

export (String, "static") var movement_type = "static"
export var animation_on_start := ""

## Timer Options
export (String, "on_time_out_start", "on_time_out_end") var destroy_on_timeout

## Size/Scale Options
export (Array, Vector2) var randomize_scale ## randomly pick from this list.

onready var anim_player = $AnimationPlayer

func _ready():
	if animation_on_start != "":
		if anim_player.has_animation(animation_on_start):
			anim_player.play(animation_on_start)
	if randomize_scale.size() > 0:
		set_scale(Helpers.choose(randomize_scale))

func _on_Timer_timeout():
	if destroy_on_timeout == "on_time_out_start":
		call_deferred("queue_free")
	
	if destroy_on_timeout == "on_time_out_end":
		call_deferred("queue_free")
