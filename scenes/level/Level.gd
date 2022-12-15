extends Node2D

onready var shift_timer = $ShiftTimer

var map
var spawn_points = []

enum FORMATION {
	enemy_name,
	spawn_rate
}

export (Array, PackedScene) var formation_set_enemies
export (Array, float) var formation_set_rates

func _ready():
	map = $map
	map.get_node("floor")
	GameData.level_map = self
	for tilemap in map.get_children():
		if tilemap.name == "floor":
			tilemap.set_bake_navigation(true)
		elif tilemap is TileMap:
			pass
#			tilemap.set_tile_origin(1) ## Center
	spawn_points = get_spawn_points()

func _process(delta):
	if shift_timer && GameData.timer_label:
		var minutes = floor(shift_timer.time_left/60)
		var seconds = shift_timer.time_left - minutes * 60
		GameData.timer_label.text = "%02d:%02d" % [minutes, seconds]

func get_spawn_points():
	var nodes =  []
	for node in get_children():
		if node.is_in_group("spawn_points"):
			nodes.push_front(node)
	return nodes

func move_to_floor_node(actor):
	## Use when actors are dead
	map.call_deferred("remove_child", actor)
	map.get_node("floor").call_deferred("add_child", actor)

func move_to_map_node(actor):
	## Use when actors are revived
	map.get_node("floor").call_deferred("remove_child", actor)
	map.call_deferred("add_child", actor)

func choose_enemy():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var enemy:PackedScene
	var tries = 3
	while !enemy || tries > 0:
		for spawn_index in formation_set_rates.size():
			var spawn_rate = formation_set_rates[spawn_index]
			var rand_float = rng.randf_range(0.0, 1.0)
			if spawn_rate >= rand_float:
				enemy = formation_set_enemies[spawn_index]
		tries -= 1
	return enemy
	

func _on_SpawnTimer_timeout():
	var spawn_point = Helpers.choose(spawn_points)
	var enemy = choose_enemy().instance()
	enemy.map_level = self
	map.add_child(enemy)
	enemy.position = spawn_point.position

func _on_ShiftTimer_timeout():
	OS.alert("Shift is over... Congrats you survived.")
