extends State
onready var timer = $Timer
export (String, "enemy", "player") var user_type = "enemy"

func enter():
	timer.start()

func _on_Timer_timeout():
	if fsm.state.name == "Dead":
		return
	this.anim_player.play("Attack")
	yield(this.anim_player, "animation_finished")
	timer.start()

func attack():
	var turret = this.get_node("Pivot/Turret")
	var target = turret.get_parent().target
	if (target is Enemy || target is Player) && target.fsm.state.name == "Dead":
		this.get_node("Pivot").target = null
		timer.stop()
		exit("Idle")
	var arrow = load("res://scenes/effects/Arrow.tscn").instance()
	var user_type_hash = {
		"player": "enemy",
		"enemies": "player"
	}
	arrow.user_type = user_type_hash[this.target_group]
	arrow.this_owner = this
	arrow.add_to_group(this.name)
	get_tree().get_root().add_child(arrow)
	arrow.global_position = turret.global_position
	if turret.get_parent().target && weakref(turret.get_parent().target).get_ref():
		var direction_toward_target = arrow.global_position.direction_to(turret.get_parent().target.global_position - Vector2(0,16)).normalized()
		arrow.direction = direction_toward_target
		arrow.look_at(turret.get_parent().target.global_position - Vector2(0,16))
	else:
		arrow.queue_free()
