extends Node2D
class_name Orbiter

onready var orbiting_obj = $Object
onready var anim_player = $AnimationPlayer
export var orbit_speed := 1
export var orbit_distance := 32
export var animation_on_start := ""
export var is_orbiting = false


func _ready():
	if animation_on_start != "":
		if anim_player.has_animation(animation_on_start):
			anim_player.play(animation_on_start)
	orbiting_obj.position.x += orbit_distance

func _physics_process(delta):
	if is_orbiting:
		rotation += (orbit_speed) * 0.001
