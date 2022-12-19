extends KinematicBody2D
class_name Bullet

onready var anim_player = get_node_or_null("AnimationPlayer")
onready var hitbox = $HitBox

export var autoplay = ""
export var speed = 10
export var destroy_on_collision := true
export (String, "enemy", "player") var user_type = "player"
export (PackedScene) var boom_scene
var boom_instance
var this_owner
var spawn_node

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

func boom():
	if boom_scene:
		boom_instance = boom_scene.instance()
	boom_instance.global_position = global_position
	if !spawn_node:
		spawn_node = GameData.level_map
	spawn_node.add_child(boom_instance)

func _on_BoomTimer_timeout():
	boom()
	if destroy_on_collision:
		queue_free()
