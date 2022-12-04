extends Node

onready var graveyard = []
var player_data = {}
var player

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
	

