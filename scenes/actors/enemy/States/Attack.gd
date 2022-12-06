extends State

onready var attack_timer = $Timer
export var attack_speed = 0.5
export var attack_rate = 1
var cur_range

func enter():
	attack_timer.wait_time = attack_rate
	cur_range = get_cur_range()
	attack()

func get_cur_range():
	return abs(this.position.distance_to(this.target.position))

func attack():
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
	attack_timer.start()

func _on_Timer_timeout():
	attack()
