extends Node2D

export (Array, String) var base_skill_list = [
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning",
	"lightning"
]
var skill_list = []
export (PackedScene) var skill_branch_scene
export (PackedScene) var skill_button_scene
onready var skill_branches = $skillBranches
var skill_buttons


func old_ready():
	skill_buttons = get_tree().get_nodes_in_group("skillBtns")
	for btn in skill_buttons:
		for spawn_loc_arr in btn.connectedBtns.keys():
			var spawn_vec = (btn.global_position + Vector2(spawn_loc_arr[0], spawn_loc_arr[1]))
			var connectedBtn = btn.connectedBtns[spawn_loc_arr]
			add_child(connectedBtn)
			connectedBtn.global_position = spawn_vec
			var branch = skill_branch_scene.instance()
			skill_branches.add_child(branch)
			branch.global_position = btn.global_position + Vector2(32,32)
			branch.points[1] = branch.to_local(connectedBtn.global_position + Vector2(32,32))

func _ready():
	skill_list = base_skill_list
#	generate_tree(skill_list.size())
	generate_tree(6)

func generate_tree(max_buttons=12):
	var root_button = get_tree().get_nodes_in_group("skillBtns")[0]
	randomize()
	## pick number of connections from root btn (min: 2, max: 8)
	var connection_ct = Helpers.choose([2,2,2,2,2,3,3,3,3,4,4,5,6,7,8])
	## pick X from skill list (x == number of connections)
	var chosen_skills = []
	for c in connection_ct:
		chosen_skills.push_front(Helpers.choose(skill_list))
	## create unresolved btns array
	var unresolved_buttons = [root_button]
	var skill_btns_created = get_tree().get_nodes_in_group("skillBtns").size()
	print(max_buttons)
	while unresolved_buttons.size() > 0:
		var button = unresolved_buttons.back()
		var button_ct_options = [2,2,2,2,2,3,3,3,3,4,4,5,6,7,8]
		var button_ct = 0
		if button.is_root_btn:
			button_ct_options = [2,2,2,2,2,3,3,3,3,4,4,5,6,7,8]
		elif skill_btns_created == max_buttons:
			button_ct_options = [0]
		elif skill_btns_created > max_buttons * 0.75 && skill_btns_created != max_buttons:
			button_ct_options = [1,2,2,3]
		elif skill_btns_created != max_buttons:
			button_ct_options = [2,2,2,2,3,3,3,4,4,5,6]
			
		button_ct = Helpers.choose(button_ct_options)
		var buttons_created = generate_branched_buttons(button, min(button_ct, max_buttons - skill_btns_created), unresolved_buttons)
		skill_btns_created += buttons_created.size()
		unresolved_buttons.pop_back()
	
	## create buttons and branches based on picks (add to unresolved btns array)
	## update button to keep track of the buttons its attached to
	## while loop of unresolved btns array, the generates more buttons and branches
	## run loop until no more buttons to resolve

func generate_branched_buttons(fromBtn, buttonCt, unresolved_buttons):
	var buttons_created = []
	if buttonCt > 0 && skill_list.size() > 0:
		for btn_index in buttonCt:
			var chosen_skill = Helpers.choose(skill_list)
			skill_list.erase(chosen_skill)
			if !chosen_skill:
				return
			var button_instance = load("res://scenes/ui/skill_buttons/{button_name}.tscn".format({"button_name": chosen_skill})).instance()
			var path_vector_options = []
			buttons_created.push_front(button_instance)
			for path_vec in fromBtn.pathVectorOptions:
				if !fromBtn.connectedBtns.has(path_vec):
					path_vector_options.push_front(path_vec)
			var spawn_vector = Helpers.choose(path_vector_options)
			fromBtn.connectedBtns[spawn_vector] = button_instance
			unresolved_buttons.push_front(button_instance)
			add_child(button_instance)
			button_instance.global_position = fromBtn.global_position + spawn_vector
			var branch = skill_branch_scene.instance()
			skill_branches.add_child(branch)
			branch.global_position = fromBtn.global_position + Vector2(32,32)
			branch.points[1] = branch.to_local(button_instance.global_position + Vector2(32,32))
	return buttons_created
			
		## spawn buttons around fromBtn
		## store spawnedBtns in unresolved buttons array

