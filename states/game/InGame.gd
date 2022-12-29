extends State


func enter():
	get_parent().HUD.visible = true

func on_HUD_btn_pressed(btn):
	exit(btn)

