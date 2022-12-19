extends Node2D
var target
var rotation_speed = 0.5
var fsm:StateMachine

var target_group

func _ready():
	yield(get_tree(), "idle_frame")
	target_group = get_parent().target_group
	fsm = get_parent().get_node("StateMachine")
	get_parent().detectbox.get_node("Area").set_collision_mask_bit(1, target_group == "player")
	get_parent().detectbox.get_node("Area").set_collision_mask_bit(2, target_group == "enemies")

func _physics_process(delta):
	call_deferred("rotate_toward_target", target)

func rotate_toward_target(_target):
	if _target && weakref(_target).get_ref():
		rotation = lerp_angle(rotation, rotation + get_angle_to(_target.global_position), rotation_speed)
		
func _on_DetectBox_target_detected(_target):
	if fsm && fsm.state.name != "Dead":
		if _target && _target.is_in_group(target_group) && _target.fsm.state.name != "Dead":
			target = _target
			fsm.change_to("Attack")

func _on_HurtBox_took_damage(amount, attacker):
	target = attacker
	if attacker is Bullet:
		target = attacker.this_owner
