extends Control

onready var text_popup = $TextPopup
onready var skillButtons = $skillButtons
onready var skill_points_label = $SkillPoints
signal close_skilltree()

func _on_skillBtn_info_btn_pressed(btn):
	text_popup.visible = true
	var display_name = btn.display_name
	text_popup.get_node("Title").text = display_name
	text_popup.get_node("Description").text = btn.description
	text_popup.current_level_desc.text = btn.current_level_desc
	text_popup.next_level_desc.text = btn.next_level_desc
	text_popup.current_level_node.set_visible(btn.current_level_desc != "")
	text_popup.next_level_node.set_visible(btn.next_level_desc != "")

func _on_Close_pressed():
	emit_signal("close_skilltree")

func _on_skillButtons_skill_btn_pressed(btn):
	skill_points_label.text = "{sp}".format({"sp": skillButtons.skill_points})
