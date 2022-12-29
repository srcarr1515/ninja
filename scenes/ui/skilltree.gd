extends Control

onready var text_popup = $TextPopup
signal close_skilltree()

func _on_skillBtn_info_btn_pressed(btn):
	text_popup.visible = true

func _on_Close_pressed():
	emit_signal("close_skilltree")
