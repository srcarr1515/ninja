extends State

onready var attack_timer = $Timer
export var attack_speed = 0.5
export var attack_rate = 1
export (String, "melee", "ranged") var attack_type = "melee"
var cur_range

func enter():
	attack_timer.wait_time = attack_rate
	cur_range = get_cur_range()
	call_deferred(attack_type)

func on_exit():
	this.hitbox.get_node("Area/Shape").set_disabled(true)

func get_cur_range():
	if this.target:
		return abs(this.position.distance_to(this.target.position))
	else:
		return 0

func melee():
#	this.anim_player.play("telegraph")
#	yield(this.anim_player, "animation_finished")
	if cur_range < get_cur_range() - 10:
		fsm.change_to("Idle")
		return
	var start_position = this.position
	var end_position = this.target.position
	this.tween.interpolate_property(
		this,
		"position",
		start_position,
		end_position,
		0.5,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN_OUT
	)
	this.hitbox.set_disabled(false)
	this.tween.start()
	yield(this.tween, "tween_completed")
	this.tween.interpolate_property(
		this,
		"position",
		end_position,
		start_position,
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	this.tween.start()
	yield(this.tween, "tween_completed")
	this.hitbox.set_disabled(true)
	attack_timer.start()

func _on_Timer_timeout():
	if fsm.state.name == "Attack":
		call_deferred(attack_type)
