extends Control

onready var text_popup = $TextPopup
onready var skillButtons = $skillButtons
onready var skill_points_label = $SkillPoints
signal close_skilltree()

func _on_skillBtn_info_btn_pressed(btn):
	text_popup.visible = true

func _on_Close_pressed():
	emit_signal("close_skilltree")

func _on_skillButtons_skill_btn_pressed(btn):
	skill_points_label.text = "{sp}".format({"sp": skillButtons.skill_points})
