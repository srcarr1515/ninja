extends State
var pause_menu

func enter():
	pause_menu = get_tree().get_nodes_in_group("pausemenu")[0]
	pause_menu.visible = true
	get_tree().paused = true

func on_pauseMenu_btn_pressed(btn):
	if btn.begins_with('#'):
		print(btn)
	else:
		get_tree().paused = false
		exit(btn)
