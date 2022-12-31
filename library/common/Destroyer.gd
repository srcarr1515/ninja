extends Node
class_name Destroyer
## This node is used to make any node auto-destructible


func _ready():
	pass # Replace with function body.

func destroy():
	get_parent().call_deferred("queue_free")

