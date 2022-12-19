extends State
onready var timer = $Timer

func enter():
	print("stunned")
	this.set_physics_process(false)
	fsm.set_physics_process(false)
	timer.start()

func _on_Timer_timeout():
	this.set_physics_process(true)
	fsm.set_physics_process(true)
	exit("Idle")
