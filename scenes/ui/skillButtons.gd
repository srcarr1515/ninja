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
	"lightning",
	"lightning",
	"lightning",
	"lightning"
]
var skill_list = []
export (PackedScene) var skill_branch_scene
export (PackedScene) var skill_button_scene
export var tree_width:= 3
export var tree_height:= 5
onready var skill_branches = $skillBranches
var tree_slots = {}
var skill_buttons

func _ready():
	skill_list = base_skill_list
#	generate_tree(skill_list.size())
	generate_tree(11)

#func _process(delta):
#	if Input.is_action_just_released("ui_select"):
#		tree_height = 8
#		generate_tree(13)

func generate_tree(max_buttons=11):
	max_buttons += 1
	var root_button = get_tree().get_nodes_in_group("skillBtns")[0]
	tree_slots[root_button.tree_slot] = root_button
	randomize()
	## create unresolved btns array
	var unresolved_buttons = [root_button]
	var skill_btns_created = get_tree().get_nodes_in_group("skillBtns").size()
	while unresolved_buttons.size() > 0:
		var button = unresolved_buttons.back()
		var button_ct_options = [2, 3]
		var button_ct = 0
		if button && button.is_root_btn:
			button_ct_options = [2,2,2,3,3,4]
		elif skill_btns_created == max_buttons:
			button_ct_options = [0]
		elif skill_btns_created > max_buttons * 0.75 && skill_btns_created != max_buttons:
			button_ct_options = [1,2,2]
		elif skill_btns_created != max_buttons:
			button_ct_options = [2, 3]
		else:
			button_ct_options = [max_buttons - skill_btns_created]
			
		button_ct = Helpers.choose(button_ct_options)
		generate_branched_buttons(button, min(button_ct, max_buttons - skill_btns_created), unresolved_buttons)
		skill_btns_created = get_tree().get_nodes_in_group("skillBtns").size()
		unresolved_buttons.pop_back()
	setSkillBtnAvailability()
	
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
				return buttons_created
			var button_instance = load("res://scenes/ui/skill_buttons/{button_name}.tscn".format({"button_name": chosen_skill})).instance()
			var path_vector_options = []
			buttons_created.push_front(button_instance)
			var new_btn_slot
			for path_vec in fromBtn.pathVectors:
				new_btn_slot = fromBtn.tree_slot + path_vec
				if !(tree_slots.has(new_btn_slot)):
					if(new_btn_slot.x >= 0 && new_btn_slot.x <= (tree_width - 1)):
						if(new_btn_slot.y >= 0 && new_btn_slot.y <= (tree_height - 1)):
							path_vector_options.push_front(path_vec)
			if path_vector_options.size() < 1:
				return buttons_created
			var spawn_vector = Helpers.choose(path_vector_options)
			var tree_slot = fromBtn.tree_slot + spawn_vector
			button_instance.tree_slot = tree_slot
			tree_slots[tree_slot] = button_instance
			fromBtn.connectedBtns[spawn_vector] = button_instance
			unresolved_buttons.push_front(button_instance)
			add_child(button_instance)
			button_instance.connect("skill_btn_pressed", self, "_on_skillBtn_skill_btn_pressed")
			button_instance.connectedBtns[-spawn_vector] = fromBtn
			button_instance.global_position = fromBtn.global_position + (spawn_vector * Vector2(fromBtn.branch_length, fromBtn.branch_length))
			var branch = skill_branch_scene.instance()
			skill_branches.add_child(branch)
			branch.global_position = fromBtn.global_position + Vector2(32,32)
			branch.points[1] = branch.to_local(button_instance.global_position + Vector2(32,32))
	return buttons_created
			
		## spawn buttons around fromBtn
		## store spawnedBtns in unresolved buttons array

func setSkillBtnAvailability():
	var skill_btns = get_tree().get_nodes_in_group("skillBtns")
	for btn in skill_btns:
		if !btn.is_available:
			for connected_btn in btn.connectedBtns.values():
				if connected_btn.skill_level > 0:
					btn.is_available = true
					btn.set_modulate(Color(1,1,1,1))
				elif !btn.is_available:
					btn.is_available = false
					btn.set_modulate(Color(0.5,0.5,0.5,1))

func _on_skillBtn_skill_btn_pressed(btn):
	if btn.is_available:
		btn.level_up()
		setSkillBtnAvailability()
