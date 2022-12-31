extends State

func enter():
	this.add_to_group("corpses")
	print("corpses")
	this.health_bar.value = 0
	this.health_bar.visible = false
	this.hurtbox.set_disabled(true)
	this.hitbox.set_disabled(true)
	this.soft_collision.set_disabled(true)
	if GameData.level_map:
		GameData.level_map.move_to_floor_node(this)
