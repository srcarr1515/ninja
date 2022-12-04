extends Node2D

onready var stage = $Stage
onready var ui = $MainCamera/UI

func _ready():
	GameData.player = get_tree().get_nodes_in_group("player")[0]
