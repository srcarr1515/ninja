extends Camera2D

func _physics_process(delta):
#	global_position = lerp(global_position, GameData.player.global_position, 1)
	global_position = GameData.player.global_position

