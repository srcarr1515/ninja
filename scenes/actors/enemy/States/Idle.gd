extends State

func enter():
	pass
	
func physics_process(delta):
	this.look_for_player()
	if !this.target:
		fsm.change_to("Escape")

