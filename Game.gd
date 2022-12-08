extends Node2D

onready var stage = $Stage
onready var ui = $MainCamera/UI

func _ready():
	GameData.hp_label = $MainCamera/UI/Label
	GameData.player = get_tree().get_nodes_in_group("player")[0]
	GameData.hp_label.text = "HP: {hp}".format({"hp": GameData.player.hurtbox.hp})
