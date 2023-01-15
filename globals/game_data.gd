extends Node

onready var graveyard = []
var game_state
var player_data = {}
var player
var joystick

var hp_label
var exit_hp_label
var timer_label
var trap_cd_label

var level_map
var level_exit
var escapee_ct = 0

var skill_data = {}
var current_skills = {}

func _ready():
	load_skill_data()

func level_skill(skill_name, skill_level):
	skill_name = str(skill_name.replace("@", "").replace(str(int(skill_name)), ""))
	## TODO: Replace existing skill for alt_action (can only be one)
	if !current_skills.has(skill_name):
		current_skills[skill_name] = {"skill_name": skill_name, "skill_level": 0}
	current_skills[skill_name]["skill_level"] = skill_level

func load_json_data(filename):
	var path = "res://data/skills.json"
	var file = File.new()
	if not file.file_exists(path):
		return
	file.open(path, file.READ)
	return parse_json(file.get_as_text())

func convert_to_vec_two(_obj):
	if typeof(_obj) == TYPE_DICTIONARY && _obj.has("Vector2"):
		return Vector2(_obj["x"], _obj["y"])
	else:
		return false

func load_skill_data():
	var data = load_json_data('skills')
	for modifier in data:
		var skill_name = modifier["Name"]
		var level = str(modifier["Level"])
		if !skill_data.has(skill_name):
			skill_data[skill_name] = {}
		if !skill_data[skill_name].has(level):
			skill_data[skill_name][level] = []
		if typeof(modifier["Value"]) == TYPE_STRING && (modifier["Value"][0] == "{" || modifier["Value"][0] == "["):
			## Detect and parse strings into ARRAYS and DICTIONARIES
			modifier["Value"] = parse_json(str(modifier["Value"]))
			## Dectect if obj is a Vector2
			var VecTwo = convert_to_vec_two(modifier["Value"])
			if VecTwo:
				modifier["Value"] = VecTwo
			elif typeof(modifier["Value"]) == TYPE_ARRAY:
				for i in modifier["Value"].size():
					var element = modifier["Value"][i]
					var _vec_two = convert_to_vec_two(element)
					if _vec_two:
						modifier["Value"][i] = _vec_two
			elif typeof(modifier["Value"]) == TYPE_DICTIONARY:
				## Untested *should work*
				for k in modifier["Value"].keys():
					var _item = modifier["Value"][k]
					var _vec_two = convert_to_vec_two(_item)
					if _vec_two:
						modifier["Value"][k] = _vec_two
		skill_data[skill_name][level].push_front(modifier)

func add_escapee():
	escapee_ct += 1
	if escapee_ct > 9:
		OS.alert("Game Over... Too many monsters escaped.")
		escapee_ct = -99

func destroy(_target):
	graveyard.push_front(_target)
	_target.queue_free()

func is_destroyed(_target):
	var is_destroyed = graveyard.has(_target)
	return is_destroyed

func remove_grave(_target):
	if is_destroyed(_target):
		graveyard.erase(_target)

func purge_graveyard():
	graveyard = []

func get_skill_data(skill_name, skill_level):
	skill_name = str(skill_name.replace("@", "").replace(str(int(skill_name)), ""))
	if !GameData.skill_data.has(skill_name):
		return null
	if !GameData.skill_data[skill_name].has(str(skill_level)):
		return null
	return GameData.skill_data[skill_name][str(skill_level)]

func apply_skill_modifiers(skill_name, node, when, instance):
	## Cleanse @ and numbers from string
#	print("applying modifiers...")
	skill_name = str(skill_name.replace("@", "").replace(str(int(skill_name)), ""))
#	print("skill_name: ", skill_name)
	var skill_data = GameData.current_skills[skill_name]
#	print("skill data: ", skill_data)
	if !GameData.skill_data[skill_name].has(str(skill_data["skill_level"])):
		print(skill_data)
		print(GameData.skill_data[skill_name].keys(), " does not contain: ", str(skill_data["skill_level"]))
		return
	var skill_modifiers = GameData.skill_data[skill_name][str(skill_data["skill_level"])]
#	print("modifiers: ", skill_modifiers)
	for modifier in skill_modifiers:
		if modifier["When"] != when:
			continue
		var subject
		if modifier["Subject"].find(".") != -1:
			## Contains a '.'
			var subject_arr = modifier["Subject"].split(".")
			if subject_arr[0] == "instance":
				subject = instance
			else:
				subject = node.get(subject_arr[0])
			subject = subject.get(subject_arr[1])
		elif modifier["Subject"] == "self":
			subject = node
		elif modifier["Subject"] == "instance":
			subject = instance
		else:
			subject = node.get(modifier["Subject"])
		if subject:
#			print(modifier["Value"])
			if typeof(modifier["Value"]) == TYPE_ARRAY:
				var new_arr = []
				for arr_item in modifier["Value"]:
					if typeof(arr_item) == TYPE_STRING && arr_item.find("res://") != -1:
						new_arr.push_front(load(arr_item))
					else:
						new_arr.push_front(arr_item)
				modifier["Value"] = new_arr
			subject.set(modifier["Attribute"], modifier["Value"])
		else:
			print("subject: {subject} not found.".format({"subject": modifier["Subject"]}))


