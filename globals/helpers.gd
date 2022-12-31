extends Node

func pick_nearest(group:String, _position:Vector2):
	var targets = get_tree().get_nodes_in_group(group)
	if targets.size() < 1:
		return
	var nearest_target = targets.front()
	if nearest_target:
		for t in targets:
			if t.global_position.distance_to(_position) < nearest_target.global_position.distance_to(_position):
				nearest_target = t
	return nearest_target

func random(exclude_list=null):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_num = randi()
	## Check random number againt list of ids you want to exclude. (to ensure uniqueness)
	if exclude_list != null:
		while random_num in exclude_list:
			random_num = randi()
	return random_num

func choose(list):
	var which_index = int(rand_range(0, list.size()))
	if which_index <= list.size() - 1:
		return list[which_index]
	else:
		return null

func get_foe(foe_type, attacker_type):
	var desired_type = foe_type
	if foe_type == "foe":
		if attacker_type == "enemy":
			desired_type = "player"
		elif attacker_type == "player":
			desired_type = "enemy"
	return desired_type
