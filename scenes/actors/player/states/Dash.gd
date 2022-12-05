extends State
## DASH
func enter():
	this.hurtbox.get_node("Area/Shape").set_disabled(true)
	this.hitbox.get_node("Area/Shape").set_disabled(false)

func on_exit():
	this.hurtbox.get_node("Area/Shape").set_disabled(false)
	this.hitbox.get_node("Area/Shape").set_disabled(true)
