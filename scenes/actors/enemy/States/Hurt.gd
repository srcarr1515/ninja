extends State
export var recovery_time = 0.5

func enter():
	this.tween.stop_all()
	yield(get_tree().create_timer(recovery_time), "timeout")
	exit("Idle")
