extends Node2D

onready var stage = $Stage
onready var ui = $MainCamera/UI
onready var camera = $MainCamera

func _ready():
	GameData.hp_label = $MainCamera/UI/HUD/Label
	GameData.exit_hp_label = $MainCamera/UI/HUD/ExitLabel
	GameData.timer_label = $MainCamera/UI/HUD/Timer
	GameData.player = get_tree().get_nodes_in_group("player")[0]
	GameData.hp_label.text = "HP: {hp}".format({"hp": GameData.player.hurtbox.hp})
	GameData.trap_cd_label = $MainCamera/UI/HUD/TrapCD
