extends State

func enter():
	this.hurtbox.set_disabled(true)
	this.hitbox.set_disabled(true)
	this.map_level.move_to_floor_node(this)
