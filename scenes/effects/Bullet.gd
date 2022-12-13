extends KinematicBody2D


onready var anim_player = $AnimationPlayer

export var autoplay = ""
export var speed = 10
export var destroy_on_collision := true

var direction := Vector2.ZERO

func _ready():
	if autoplay != "":
		anim_player.play(autoplay)

func _physics_process(delta):
	var velocity = direction * speed * delta
	move_and_collide(velocity)

func _on_HitBox_on_hit(target, damage):
	if destroy_on_collision:
		queue_free()
