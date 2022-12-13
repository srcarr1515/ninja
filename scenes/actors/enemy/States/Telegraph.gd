extends State

func enter():
	this.anim_player.play("telegraph")
	yield(this.anim_player, "animation_finished")
	fsm.change_to("Attack")
