extends Node2D

export (PackedScene) var rootSkillBtn

export (Array, String) var base_skill_list = [
	"AutoCrossbow",
	"AutoCrossbow",
	"AutoCrossbow",
	"AutoCrossbow",
	"AutoCrossbow",
	"AutoCrossbow",
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
export var skill_points := 0
export (PackedScene) var skill_branch_scene
export (PackedScene) var skill_button_scene
export var tree_width:= 3
export var tree_height:= 6
onready var skill_branches = $skillBranches
var tree_slots = {}
var skill_buttons

signal skill_btn_pressed(btn)

func _ready():
	skill_list = base_skill_list
	var rootBtn = rootSkillBtn.instance()
	rootBtn.skill_level = 1
	add_child(rootBtn)
	rootBtn.position = get_node("rootBtnPosition").position
	rootBtn.connect("skill_btn_pressed", self, "_on_skillBtn_skill_btn_pressed")
	rootBtn.connect("info_btn_pressed", get_parent(), "_on_skillBtn_info_btn_pressed")
	rootBtn.is_available = true
	rootBtn.is_root_btn = true
	rootBtn.max_level = 5
	rootBtn.tree_slot = Vector2(1,0)
	generate_tree(15)


func generate_tree(max_buttons):
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
			button_ct_options = [2,3]
		elif skill_btns_created == max_buttons:
			button_ct_options = [0]
		elif skill_btns_created > max_buttons * 0.75 && skill_btns_created != max_buttons:
			button_ct_options = [1,2,2]
		elif skill_btns_created != max_buttons:
			button_ct_options = [2, 3]
		
		if max_buttons - skill_btns_created <= 3:
			button_ct_options = [max_buttons - skill_btns_created]
			
		button_ct = Helpers.choose(button_ct_options)
		generate_branched_buttons(button, min(button_ct, max_buttons - skill_btns_created), unresolved_buttons)
		skill_btns_created = get_tree().get_nodes_in_group("skillBtns").size()
		unresolved_buttons.pop_back()
	setSkillBtnAvailability()

func generate_branched_buttons(fromBtn, buttonCt, unresolved_buttons):
	var buttons_created = []
	if buttonCt > 0 && skill_list.size() > 0:
		for btn_index in buttonCt:
			var chosen_skill = Helpers.choose(skill_list)
			if !chosen_skill:
				return buttons_created
			var button_instance = load("res://scenes/ui/skill_buttons/{button_name}.tscn".format({"button_name": chosen_skill})).instance()
			var path_vector_options = []
			buttons_created.push_front(button_instance)
			var new_btn_slot
			var slots_checked = []
			for path_vec in fromBtn.pathVectors:
				new_btn_slot = fromBtn.tree_slot + path_vec
				slots_checked.push_back(new_btn_slot)
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
			button_instance.connect("info_btn_pressed", get_parent(), "_on_skillBtn_info_btn_pressed")
			button_instance.connectedBtns[-spawn_vector] = fromBtn
			button_instance.global_position = fromBtn.global_position + (spawn_vector * Vector2(fromBtn.branch_length, fromBtn.branch_length))
			var branch = skill_branch_scene.instance()
			skill_branches.add_child(branch)
			branch.global_position = fromBtn.global_position + Vector2(32,32)
			branch.points[1] = branch.to_local(button_instance.global_position + Vector2(32,32))
			skill_list.erase(chosen_skill)
	return buttons_created

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
	if btn.is_available && skill_points > 0 && btn.skill_level < btn.max_level:
		skill_points -= 1
		skill_points = max(0, skill_points)
		btn.level_up()
		setSkillBtnAvailability()
		emit_signal("skill_btn_pressed", btn)
