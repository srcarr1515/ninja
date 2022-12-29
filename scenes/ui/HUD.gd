extends Control

signal HUD_btn_pressed(btn_name)

func _on_SkillTreeBtn_pressed():
	emit_signal("HUD_btn_pressed", "SkillTree")


func _on_MenuButton_pressed():
	emit_signal("HUD_btn_pressed", "PauseMenu")
