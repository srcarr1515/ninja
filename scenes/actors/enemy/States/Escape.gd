extends State

func physics_process(delta):
	this.target = GameData.level_exit
	this.look_for_player()
	if !(this.target is Player):
		if this.nav_agent.is_navigation_finished():
			return
		var target_pos = this.nav_agent.get_next_location()
		var direction = this.global_position.direction_to(target_pos)
		var velocity = direction * this.nav_agent.max_speed
		this.set_flip_h(this.x_flip_on_move && velocity.x < 0)
		this.move_and_slide(velocity)
