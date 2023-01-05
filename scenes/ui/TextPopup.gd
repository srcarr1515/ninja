extends Popup

onready var current_level_desc = $CurrentLevel/Description
onready var next_level_desc = $NextLevel/Description
onready var current_level_node = $CurrentLevel
onready var next_level_node = $NextLevel

func _on_Close_pressed():
	set_visible(false)
