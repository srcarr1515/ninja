extends Node2D

var spawn_points = []

func _ready():
	spawn_points = get_spawn_points()

func get_spawn_points():
	var nodes =  []
	for node in get_children():
		if node.is_in_group("spawn_points"):
			nodes.push_front(node)
	return nodes

func _on_Timer_timeout():
	var spawn_point = Helpers.choose(spawn_points)
	var enemy = load("res://scenes/actors/enemy/Enemy.tscn").instance()
	add_child(enemy)
	enemy.position = spawn_point.position
