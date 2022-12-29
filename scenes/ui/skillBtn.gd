extends TouchScreenButton

export var skill_level = 0
export var is_available = false
export var is_root_btn = false

onready var connectedBtns = {}

export var pathVectors = [
	Vector2(1,1),
	Vector2(0,1),
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(-1,1),
]

export var description := ""
export var display_name := ""

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

func _on_skillBtn_released():
	emit_signal("skill_btn_pressed", self)

func level_up():
	skill_level += 1
	self.set_modulate(Color(0.9, 0.14, 0.14))

func _on_info_released():
	print('info')
	emit_signal("info_btn_pressed", self)
