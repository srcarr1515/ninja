extends StateMachine
var HUD
var pause_menu

func _ready():
	HUD = get_tree().get_nodes_in_group("HUD")[0]
	pause_menu = get_tree().get_nodes_in_group("pausemenu")[0]
	HUD.connect("HUD_btn_pressed", get_node("InGame"), "on_HUD_btn_pressed")
	pause_menu.connect("pauseMenuBtn", get_node("PauseMenu"), "on_pauseMenu_btn_pressed")

func _on_MainMenu_btn_pressed(button, data):
	this.ui = this.get_node("MainCamera/UI")
	if state.name == "MainMenu":
		state.on_MainMenu_btn_pressed(button, data)

func  _enter_state():
	yield(get_tree(), "idle_frame")
	get_parent().get_node("MainCamera").hide_all_ui()
	._enter_state()
	GameData.game_state = state.name
	print(GameData.game_state)

