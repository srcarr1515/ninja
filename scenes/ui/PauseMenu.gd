extends Control

signal pauseMenuBtn(btn)

func _on_Close_pressed():
	emit_signal("pauseMenuBtn", "InGame")


func _on_Retry_pressed():
	emit_signal("pauseMenuBtn", "#retry")


func _on_Home_pressed():
	emit_signal("pauseMenuBtn", "#home")
