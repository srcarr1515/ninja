extends KinematicBody2D

onready var nav_agent := $NavAgent
onready var nav_timer := $NavTimer
onready var sprite := $Sprite
onready var hitbox := $HitBox
onready var detectbox := $DetectBox
onready var hurtbox := $HurtBox
onready var fsm := $StateMachine
onready var los = $LineOfSight
onready var attention_timer = $AttentionTimer
onready var tween := $Tween
var los_instance

export var line_of_sight_range := 120
var target

func _ready():
	nav_agent.connect("velocity_computed", self, "_on_velocity_computed")

func _on_velocity_computed(velocity):
	pass

func look_for_player():
	if GameData.player:
		var los_range = min(los.global_position.distance_to(GameData.player.global_position), line_of_sight_range)
		los.cast_to = (los.global_position.direction_to(GameData.player.global_position) * los_range)
		los.force_raycast_update()
		if los.is_colliding():
			if los.get_collider().is_in_group("player"):
				target = los.get_collider()
				fsm.change_to("Chase")
				attention_timer.start()

func _on_NavTimer_timeout():
	if GameData.player.global_position:
		nav_agent.set_target_location(GameData.player.global_position)

func _on_DetectBox_no_targets_remain():
	pass

func _on_DetectBox_target_detected(_target):
	if fsm.state.name != "Hurt":
		fsm.change_to("Attack")

func _on_HurtBox_is_dead():
	queue_free()

func _on_HurtBox_took_damage(amount):
	fsm.change_to("Hurt")
