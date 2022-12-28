extends TouchScreenButton

export var skill_level = 0
export var is_available = false
export var is_root_btn = false
onready var btn = $btn

onready var connectedBtns = {}

export var pathVectorOptions = [
	Vector2(96,96),
	Vector2(-96,-96),
	Vector2(0,96),
	Vector2(96,0),
	Vector2(-96,0),
	Vector2(0,-96),
	Vector2(-96,96),
	Vector2(96,-96),
]

export var branch_length = 64



