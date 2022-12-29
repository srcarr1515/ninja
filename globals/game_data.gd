extends Node

onready var graveyard = []
var game_state
var player_data = {}
var player
var joystick

var hp_label
var exit_hp_label
var timer_label
var trap_cd_label

var level_map
var level_exit
var escapee_ct = 0

func add_escapee():
	escapee_ct += 1
	if escapee_ct > 9:
		OS.alert("Game Over... Too many monsters escaped.")
		escapee_ct = -99

func destroy(_target):
	graveyard.push_front(_target)
	_target.queue_free()

func is_destroyed(_target):
	var is_destroyed = graveyard.has(_target)
	return is_destroyed

func remove_grave(_target):
	if is_destroyed(_target):
		graveyard.erase(_target)

func purge_graveyard():
	graveyard = []
	

