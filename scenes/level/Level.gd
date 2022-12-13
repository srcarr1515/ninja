extends Node2D

var map
var spawn_points = []

func _ready():
	map = $map
	map.get_node("floor").set_bake_navigation(true)
	spawn_points = get_spawn_points()

func get_spawn_points():
	var nodes =  []
	for node in get_children():
		if node.is_in_group("spawn_points"):
			nodes.push_front(node)
	return nodes

func move_to_floor_node(actor):
	## Use when actors are dead
	map.remove_child(actor)
	map.get_node("floor").add_child(actor)

func move_to_map_node(actor):
	## Use when actors are revived
	map.get_node("floor").remove_child(actor)
	map.add_child(actor)

func _on_Timer_timeout():
	var spawn_point = Helpers.choose(spawn_points)
	var enemy = load("res://scenes/actors/enemy/Bat.tscn").instance()
	enemy.map_level = self
	map.add_child(enemy)
	enemy.position = spawn_point.position
