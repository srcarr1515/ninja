extends Node

export (Array, PackedScene) var on_move_skills = []

onready var on_move_timer = $OnMove
var subject

func _on_move(subject):
	if on_move_timer.is_stopped():
		on_move_timer.start()

func _on_OnMove_timeout():
	for move_skill in on_move_skills:
		var effect = move_skill.instance()
		GameData.level_map.add_child(effect)
		effect.global_position = subject.global_position
		subject.z_index = effect.z_index + 1
