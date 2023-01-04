extends TouchScreenButton

export var skill_level := 0 setget set_skill_level, get_skill_level
export var is_available = false
export var is_root_btn = false

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
export var display_name := ""
export var max_level := 20

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
	set_skill_level(skill_level)

func _on_skillBtn_released():
	emit_signal("skill_btn_pressed", self)

func level_up():
	set_skill_level(skill_level + 1)
#	self.set_modulate(Color(0.9, 0.14, 0.14))

func set_skill_level(_new_level):
	_new_level = clamp(_new_level, 0, max_level)
	if _new_level != skill_level:
		skill_level = _new_level
	if skill_level_label:
		skill_level_label.text = "{skill_level}/{max_skill_level}".format({"skill_level": skill_level, "max_skill_level": max_level})

func get_skill_level():
	return skill_level

func _on_info_released():
	emit_signal("info_btn_pressed", self)
