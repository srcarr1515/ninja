extends State

func enter():
	if this && this.anim_player:
		this.anim_player.play("Idle_Down")

#func process(delta):
#	if this && this.anim_player && this.anim_player.current_animation != "Idle_Down":
#		this.anim_player.play("Idle_Down")
