extends Node
class_name State

onready var fsm : StateMachine
onready var this : Object

var transitions = {}

func enter():
	pass

func exit(next_state):
	if fsm:
		fsm.change_to(next_state)

func ready():
	pass

func process(_delta):
	# Replace pass with your handler code
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass

func unhandled_input(_event):
	pass

func unhandled_key_input(_event):
	pass

func notification(_what, _flag = false):
	pass
