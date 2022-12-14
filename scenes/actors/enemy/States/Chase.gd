extends State

func enter():
	this.hurtbox.set_disabled(false)
	this.hitbox.set_disabled(true)

func physics_process(delta):
	this.look_for_player()
	if !this.target:
		fsm.change_to("Idle")
	else:
		if this.nav_agent.is_navigation_finished():
			return
		var target_pos = this.nav_agent.get_next_location()
		var direction = this.global_position.direction_to(target_pos)
		var velocity = direction * this.nav_agent.max_speed
		if this.x_flip_on_move && velocity.x < 0:
			this.sprite.set_flip_h(true)
		else:
			this.sprite.set_flip_h(false)
		this.move_and_slide(velocity)
