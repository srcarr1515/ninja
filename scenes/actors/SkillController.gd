extends Node

var on_move_skills := []
var on_player_skills := []
var on_player_active = []

onready var on_move_timer = $OnMove
var subject

func _ready():
	yield(get_tree(),"idle_frame")
	activate_on_player_skills()

func add_skill(skill_scene:PackedScene, skill_list_name:String):
	var skill_list = get(skill_list_name)
	if !skill_list.has(skill_scene):
		skill_list.push_front(skill_scene)
		set(skill_list_name, skill_list)
	if skill_list_name == "on_player_skills":
		var _filename = skill_scene.get_path()
		var skill_to_remove
		for active_skill in on_player_active:
			if _filename == active_skill.filename:
				skill_to_remove = active_skill
		if skill_to_remove:
			on_player_active.erase(skill_to_remove)
			skill_to_remove.queue_free()
		activate_on_player_skills()

func activate_on_player_skills():
	for skill in on_player_skills:
		if !on_player_active.has(skill):
			var effect = skill.instance()
			GameData.apply_skill_modifiers(effect.name, self, "beforeAdd", effect)
			GameData.level_map.add_child(effect)
			GameData.apply_skill_modifiers(effect.name, self, "afterAdd", effect)
			effect.global_position = subject.global_position
			subject.z_index = effect.z_index + 1
			on_player_active.push_front(effect)

func _on_move(subject):
	if on_move_timer.is_stopped():
		on_move_timer.start()

func _on_OnMove_timeout():
	for move_skill in on_move_skills:
		var effect = move_skill.instance()
		GameData.apply_skill_modifiers(effect.name, self, "beforeAdd", effect)
		GameData.level_map.add_child(effect)
		GameData.apply_skill_modifiers(effect.name, self, "afterAdd", effect)
		effect.global_position = subject.global_position
		subject.z_index = effect.z_index + 1
