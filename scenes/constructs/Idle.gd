extends State

func enter():
	if this && this.anim_player:
		this.anim_player.play("Idle")
