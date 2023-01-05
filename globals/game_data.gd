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

func level_skill(skill_type, skill_name, skill_level):
	skill_name = str(skill_name.replace("@", "").replace(str(int(skill_name)), ""))
	## TODO: Replace existing skill for alt_action (can only be one)
	if !current_skills.has(skill_type):
		current_skills[skill_type] = {}
	if !current_skills[skill_type].has(skill_name):
		current_skills[skill_type][skill_name] = {"skill_name": skill_name, "skill_level": 0}
	current_skills[skill_type][skill_name]["skill_level"] = skill_level

func load_json_data(filename):
	var path = "res://data/skills.json"
	var file = File.new()
	if not file.file_exists(path):
		return
	file.open(path, file.READ)
	return parse_json(file.get_as_text())

func load_skill_data():
	var data = load_json_data('skills')
	for modifier in data:
		var skill_name = modifier["Name"]
		var level = str(modifier["Level"])
		var skill_type = modifier["SkillType"]
		if !skill_data.has(skill_type):
			skill_data[modifier["SkillType"]] = {}
		if !skill_data[skill_type].has(skill_name):
			skill_data[skill_type][skill_name] = {}
		if !skill_data[skill_type][skill_name].has(level):
			skill_data[skill_type][skill_name][level] = []
		skill_data[skill_type][skill_name][level].push_front(modifier)

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

func get_skill_data(skill_type, skill_name, skill_level):
	skill_name = str(skill_name.replace("@", "").replace(str(int(skill_name)), ""))
	if !GameData.skill_data.has(skill_type):
		return null
	if !GameData.skill_data[skill_type][skill_name].has(str(skill_level)):
		return null
	return GameData.skill_data[skill_type][skill_name][str(skill_level)]

func apply_skill_modifiers(skill_type, skill_name, node, when):
	## Cleanse @ and numbers from string
	skill_name = str(skill_name.replace("@", "").replace(str(int(skill_name)), ""))
	var skill_data = GameData.current_skills[skill_type][skill_name]
	if !GameData.skill_data[skill_type][skill_name].has(str(skill_data["skill_level"])):
		print(skill_data)
		print(GameData.skill_data[skill_type][skill_name].keys(), " does not contain: ", str(skill_data["skill_level"]))
		return
	var skill_modifiers = GameData.skill_data[skill_type][skill_name][str(skill_data["skill_level"])]
	for modifier in skill_modifiers:
		if modifier["When"] != when:
			continue
		var subject
		if modifier["Subject"].find(".") != -1:
			## Contains a '.'
			var subject_arr = modifier["Subject"].split(".")
			subject = node.get(subject_arr[0])
			subject = subject.get(subject_arr[1])
		elif modifier["Subject"] == "self":
			subject = node
		else:
			subject = node.get(modifier["Subject"])
		
		if subject:
			subject.set(modifier["Attribute"], modifier["Value"])
		else:
			print("subject: {subject} not found.".format({"subject": modifier["Subject"]}))
	
	

