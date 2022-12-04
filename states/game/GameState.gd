extends StateMachine

func _on_MainMenu_btn_pressed(button, data):
	this.ui = this.get_node("MainCamera/UI")
	if state.name == "MainMenu":
		state.on_MainMenu_btn_pressed(button, data)
