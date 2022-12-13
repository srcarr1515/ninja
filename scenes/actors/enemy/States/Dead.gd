extends State

func enter():
	this.hurtbox.set_disabled(true)
	this.hitbox.set_disabled(true)
	this.soft_collision.set_disabled(true)
	if this.map_level:
		this.map_level.move_to_floor_node(this)
