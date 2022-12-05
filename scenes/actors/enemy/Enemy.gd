extends KinematicBody2D

onready var nav_agent := $NavAgent
onready var nav_timer := $NavTimer
onready var sprite := $Sprite
onready var hitbox := $HitBox
onready var detectbox := $DetectBox
onready var hurtbox := $HurtBox
onready var state_machine := $StateMachine

func _ready():
	nav_agent.connect("velocity_computed", self, "_on_velocity_computed")

func _on_velocity_computed(velocity):
	pass

func _on_NavTimer_timeout():
	if GameData.player.global_position:
		nav_agent.set_target_location(GameData.player.global_position)

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	var target_pos = nav_agent.get_next_location()
	var direction = global_position.direction_to(target_pos)
	var velocity = direction * nav_agent.max_speed
	move_and_slide(velocity)
