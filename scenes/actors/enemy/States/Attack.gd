extends State

onready var attack_timer = $Timer
export var attack_speed = 0.5
export var attack_rate = 1
export (String, "melee", "ranged") var attack_type = "melee"
export var max_range:= 48
var cur_range

func enter():
	attack_timer.wait_time = attack_rate
	cur_range = clamp(get_cur_range(), 0, max_range)
	call_deferred(attack_type)

func on_exit():
	this.hitbox.get_node("Area/Shape").set_disabled(true)
	if this.right_pivot:
		this.right_pivot.position = Vector2.ZERO
		this.left_pivot.position = Vector2.ZERO

func get_cur_range():
	if this.target:
		return abs(this.position.distance_to(this.target.position))
	else:
		return 0

func ranged():
	if cur_range < get_cur_range() - 10:
		fsm.change_to("Idle")
		return
	var move_vector = (this.global_position.direction_to(this.target.global_position)).normalized()
	this.set_flip_h(this.x_flip_on_move && move_vector.x < 0)
	this.right_pivot.look_at(this.target.global_position)
	this.left_pivot.look_at(this.target.global_position)
	var abs_pivot_rotation = abs(this.left_pivot.rotation)
	if abs_pivot_rotation < 1 && abs_pivot_rotation > 0:
		this.right_pivot.position = Vector2.ZERO
		this.left_pivot.position = Vector2.ZERO
	elif this.left_pivot.rotation < 0:
		this.left_pivot.position = Vector2(12, -12)
		this.right_pivot.position = Vector2(12, -12)
	elif this.left_pivot.rotation > 1:
		this.left_pivot.position = Vector2(-12, -12)
		this.right_pivot.position = Vector2(-12, -12)
	attack_timer.start()

func shoot():
	var arrow = load("res://scenes/effects/Arrow.tscn").instance()
	arrow.user_type = "enemy"
	arrow.this_owner = this
	arrow.add_to_group(this.name)
	get_tree().get_root().add_child(arrow)
	arrow.global_position = this.right_pivot.get_node("Right").global_position
	var direction_toward_target = arrow.global_position.direction_to(this.target.global_position - Vector2(0,16)).normalized()
	arrow.direction = direction_toward_target
	arrow.look_at(this.target.global_position - Vector2(0,16))

 
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
	if GameData.level_exit.is_open:
		this.queue_free()
		GameData.add_escapee()
		GameData.exit_hp_label.text = "Escaped Monsters: {ct}".format({"ct": GameData.escapee_ct})
	if fsm.state.name == "Attack":
		this.play_state_animation(fsm.state)
		call_deferred(attack_type)

