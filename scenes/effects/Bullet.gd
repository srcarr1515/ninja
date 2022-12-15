extends KinematicBody2D


onready var anim_player = $AnimationPlayer
onready var hitbox = $HitBox

export var autoplay = ""
export var speed = 10
export var destroy_on_collision := true
export (String, "enemy", "player") var user_type = "player"
var this_owner

var direction := Vector2.ZERO

func _ready():
	hitbox.get_node("Area").set_collision_mask_bit(1, user_type == "enemy")
	hitbox.get_node("Area").set_collision_mask_bit(2, user_type == "player")
	if autoplay != "":
		anim_player.play(autoplay)

func _physics_process(delta):
	var velocity = direction * speed * delta
	move_and_collide(velocity)

func _on_HitBox_on_hit(target, damage):
	if destroy_on_collision:
		queue_free()
