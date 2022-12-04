extends State
var main_menu

func enter():
	main_menu = load("res://scenes/ui/main_menu.tscn").instance()
	var ui = this.get_node("MainCamera/UI")
	if ui:
		ui.add_child(main_menu)
		main_menu.connect("menu_btn_pressed", this.get_node("GameState"), "_on_MainMenu_btn_pressed")
	
func on_MainMenu_btn_pressed(_button, _data):
	if _button == "start":
		exit("InGame")
		main_menu.queue_free()
		
