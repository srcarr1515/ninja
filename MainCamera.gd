extends Camera2D
onready var ui = $UI

func _physics_process(delta):
#	global_position = lerp(global_position, GameData.player.global_position, 1)
	global_position = GameData.player.global_position

func hide_all_ui():
	for u in ui.get_children():
		u.visible = false
