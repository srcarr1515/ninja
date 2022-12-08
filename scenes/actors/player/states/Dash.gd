extends State
## DASH
func enter():
	this.hurtbox.get_node("Area/Shape").set_disabled(true)
	this.hitbox.get_node("Area/Shape").set_disabled(false)

func on_exit():
	yield(get_tree().create_timer(0.05), "timeout")
	this.hitbox.get_node("Area/Shape").set_disabled(true)
	this.hurtbox.get_node("Area/Shape").set_disabled(false)
