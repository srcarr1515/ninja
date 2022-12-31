extends KinematicBody2D
class_name Enemy

onready var nav_agent := $NavAgent
onready var nav_timer := $NavTimer
onready var character := $Character
onready var sprite := $Character/Sprite
onready var hitbox := $HitBox
onready var detectbox := $DetectBox
onready var hurtbox := $HurtBox
onready var fsm := $StateMachine
onready var los = $LineOfSight
onready var attention_timer = $AttentionTimer
onready var tween := $Tween
onready var anim_player = $AnimationPlayer
onready var v_notifier = $VisibilityNotifier2D
onready var soft_collision = $SoftCollision
onready var health_bar = $HealthBar
var left_pivot
var right_pivot

var los_instance
var map_level
var velocity = Vector2.ZERO

export var x_flip_on_move := false
export var line_of_sight_range := 120
var target
export var flip_h := false 

func _ready():
	nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	fsm.this = self
	left_pivot = get_node_or_null("Character/LeftPivot")
	right_pivot = get_node_or_null("Character/RightPivot")
	if anim_player.has_animation(fsm.state.name):
		anim_player.play(fsm.state.name)

func set_flip_h(is_flipped:bool):
	flip_h = is_flipped
	if flip_h:
		character.scale.x = abs(character.scale.x) * -1
	else:
		character.scale.x = abs(character.scale.x)

func _on_velocity_computed(velocity):
	pass

func _physics_process(delta):
	if fsm.state.name != "Dead":
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * delta * 100
		else:
			velocity = Vector2.ZERO
		velocity = move_and_slide(velocity)

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
	if is_instance_valid(target):
		if target is Player || target is Exit || target is Construct:
			nav_agent.set_target_location(target.global_position)

func _on_DetectBox_no_targets_remain():
	pass

func _on_DetectBox_target_detected(_target):
	if fsm.state.name == "Chase" || fsm.state.name == "Escape":
		target = _target
		fsm.change_to("Attack")

func _on_HurtBox_is_dead():
	pass

func _on_HurtBox_took_damage(amount, attacker):
	if fsm.state.name == "Dead":
		return
	target = attacker
	if attacker is Bullet:
		target = attacker.this_owner
	if hurtbox.hp > 0:
		var perc_hp = (float(hurtbox.hp)/float(hurtbox.max_hp)) * 100
		health_bar.set_health_bar(perc_hp)
		fsm.change_to("Hurt")
	else:
		fsm.change_to("Dead")

func _on_AttentionTimer_timeout():
	pass

func play_state_animation(_state):
	var state = _state.name
	if _state.name == "Escape":
		state = "Chase"
	if anim_player.has_animation(state):
		anim_player.play(state)
	elif _state.name == "Attack" && anim_player.has_animation("BowAttack"):
		anim_player.play("BowAttack")

func _on_StateMachine_on_change_state(_state):
	play_state_animation(_state)
