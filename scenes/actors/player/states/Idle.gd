extends State

func enter():
	if this && this.anim_player:
		this.anim_player.play("Idle_{dir}".format({"dir": this.last_known_dir}))

#func process(delta):
#	if this && this.anim_player && this.anim_player.current_animation != "Idle_Down":
#		this.anim_player.play("Idle_Down")
