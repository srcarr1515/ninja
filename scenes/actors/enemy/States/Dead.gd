extends State

func enter():
	this.hurtbox.get_node("Area/Shape").set_disabled(true)
	this.hitbox.get_node("Area/Shape").set_disabled(true)
