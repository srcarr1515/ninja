extends TouchScreenButton

export (String, "dash", "on_player_skill", "on_move_skill", "buff", "alt_action", "alt_action_buff") var skill_type ## Tells it where it should go
export var subtype := ""
var skill_name:String
export var skill_level := 0 setget set_skill_level, get_skill_level
export var is_available = false
export var is_root_btn = false
onready var skill_icon = $SkillIcon
onready var connectedBtns = {}
onready var skill_level_label = $SkillLevel

export var pathVectors = [
	Vector2(1,1),
	Vector2(0,1),
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(-1,1),
]

export var description := ""
var current_level_desc := ""
var next_level_desc := ""
export var display_name := ""
export var max_level := 20

export (Array, Dictionary) var level_guide = []

#export var pathVectors = [
#	Vector2(1,1),
#	Vector2(-1,-1),
#	Vector2(0,1),
#	Vector2(1,0),
#	Vector2(-1,0),
#	Vector2(0,-1),
#	Vector2(-1,1),
#	Vector2(1,-1),
#]

export var branch_length = 116
export (Vector2) var tree_slot

signal skill_btn_pressed(btn)
signal info_btn_pressed(btn)

func _ready():
#	max_level = level_guide.size()
	var skill_data = GameData.get_skill_data(skill_name, 0)
	if skill_data != null:
		## Set description/display name based off of a Level 0 configuration in skill_data
		for item in skill_data:
			set(item["Attribute"], item["Value"])
		max_level = int(GameData.skill_data[skill_name].keys().max())
	if skill_name != "":
		skill_icon.set_texture(load("res://assets/graphics/ui/skill_icons/{skill_name}.png".format({"skill_name": skill_name})))
	set_skill_level(skill_level)
		
func _on_skillBtn_released():
	emit_signal("skill_btn_pressed", self)

func level_up():
	set_skill_level(skill_level + 1)
#	self.set_modulate(Color(0.9, 0.14, 0.14))

func set_level_description(level=skill_level, which_level_desc="current_level_desc"):
	var skill_data = GameData.get_skill_data(skill_name, level)
	print(skill_name)
	var new_description = ""
	set(which_level_desc, "")
	if skill_data != null:
		for item in skill_data:
			var x = item["Value"]
			var desc = ""
			if item["Description"] != null:
				desc = item["Description"].format({"x": x, "name": item["Name"]})
				new_description += "* "
				new_description += desc
				new_description += "\n"
	set(which_level_desc, new_description)

func set_skill_level(_new_level):
	_new_level = clamp(_new_level, 0, max_level)
	GameData.level_skill(skill_name, _new_level)
	if _new_level != skill_level:
		skill_level = _new_level
	## Set skill level descriptions
	set_level_description()
	set_level_description(skill_level + 1, "next_level_desc")
	## Add skill to player
	if GameData && GameData.player:
		if skill_type == "buff":
			GameData.player.buff_controller.remove_buff(skill_name, skill_level - 1)
			GameData.player.buff_controller.add_buff(skill_name, skill_level, subtype)
		elif skill_type == "alt_action_buff":
			GameData.player.add_alt_action_buff(skill_name, skill_level, subtype)
		else:
			GameData.player.add_skill(skill_name, skill_type)
	if skill_level_label:
		skill_level_label.text = "{skill_level}/{max_skill_level}".format({"skill_level": skill_level, "max_skill_level": max_level})

func add_skill_to_zone():
	pass

func get_skill_level():
	return skill_level

func _on_info_released():
	emit_signal("info_btn_pressed", self)
