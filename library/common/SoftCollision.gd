extends Area2D

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if areas.size() > 0:
		var area = areas[0]
		
		var random_dir_change = -1 if randf() < 0.5 else 1
		if area.global_position == global_position:
			push_vector = Helpers.choose([
				Vector2(1,0), 
				Vector2(0,1), 
				Vector2(1,1),
				Vector2(-1, 0),
				Vector2(0, -1),
				Vector2(-1,-1)
				])
		else:
			push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func set_disabled(is_disabled:bool):
	get_node("CollisionShape2D").call_deferred("set_disabled", is_disabled)
