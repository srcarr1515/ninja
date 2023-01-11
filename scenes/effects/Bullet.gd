extends KinematicBody2D
class_name Bullet

onready var anim_player = get_node_or_null("AnimationPlayer")
onready var hitbox = $HitBox

export var autoplay = ""
export var speed = 10
export var destroy_on_collision := true
export (String, "enemy", "player") var user_type = "player"
export (String, "enemies", "player") var target_group = "enemies"
export (PackedScene) var boom_scene
export (String, "on_boom_timer", "on_collision") var boom_trigger := "on_boom_timer"
var follow_target
var look_at_position_offset:=Vector2(0,0)
var boom_instance
var this_owner
var spawn_node

var direction := Vector2.ZERO

func _ready():
	hitbox.get_node("Area").set_collision_mask_bit(1, target_group == "player")
	hitbox.get_node("Area").set_collision_mask_bit(2, target_group == "enemies")
	if autoplay != "":
		anim_player.play(autoplay)

func _physics_process(delta):
	if follow_target:
		look_at(follow_target.global_position + look_at_position_offset)
		follow_target.global_position
		direction = global_position.direction_to(follow_target.global_position)
	var velocity = direction * speed * delta
	move_and_collide(velocity)

func _on_HitBox_on_hit(target, damage):
	if boom_trigger == "on_collision":
		boom()
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
	if boom_trigger == "on_boom_timer":
		boom()
		if destroy_on_collision:
			queue_free()
