extends Node

export (Array, PackedScene) var on_move_skills = []
export (Array, PackedScene) var on_player_skills = []
var on_player_active = []

onready var on_move_timer = $OnMove
var subject

func _ready():
	yield(get_tree(),"idle_frame")
	activate_on_player_skills()

func activate_on_player_skills():
	for skill in on_player_skills:
		if !on_player_active.has(skill):
			var effect = skill.instance()
			GameData.level_map.add_child(effect)
			effect.global_position = subject.global_position
			subject.z_index = effect.z_index + 1
			on_player_active.push_front(skill)

func _on_move(subject):
	if on_move_timer.is_stopped():
		on_move_timer.start()

func _on_OnMove_timeout():
	for move_skill in on_move_skills:
		var effect = move_skill.instance()
		GameData.level_map.add_child(effect)
		effect.global_position = subject.global_position
		subject.z_index = effect.z_index + 1
