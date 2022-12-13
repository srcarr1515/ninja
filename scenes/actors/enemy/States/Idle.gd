extends State

func enter():
	print("Idle")
	
func physics_process(delta):
	this.look_for_player()

