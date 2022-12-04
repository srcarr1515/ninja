extends Control

signal menu_btn_pressed(button, data)

func _on_StartBtn_pressed():
	emit_signal("menu_btn_pressed", "start", null)

func _on_LoadBtn_pressed():
	pass # Replace with function body.
	## TODO: Add scene with save games
	## TODO: emit signal that game is loaded and pass file info/pointer

func _on_OptionsBtn_pressed():
	pass # Replace with function body.

func _on_QuitBtn_pressed():
	get_tree().quit()
