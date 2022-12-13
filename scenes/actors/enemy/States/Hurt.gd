extends State
export var recovery_time = 0.5

func enter():
	this.tween.stop_all()
	this.anim_player.play("hurt")
	this.hitbox.get_node("Area/Shape").set_disabled(true)
	yield(get_tree().create_timer(recovery_time), "timeout")
	this.hitbox.get_node("Area/Shape").set_disabled(false)
	exit(fsm.history.front())
