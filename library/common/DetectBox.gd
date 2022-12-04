extends Node2D

onready var this = get_parent()
onready var area = $Area
var target : Object = null

signal target_detected(_target)
signal no_targets_remain

func _on_Area_area_entered(_area):
	target = _area.get_parent().this
	if target != this && target != null:
		emit_signal("target_detected", target)

func _physics_process(_delta):
	var overlapping_targets = area.get_overlapping_areas()
	if(overlapping_targets.size() < 1) && target != null:
		target = null
		emit_signal("no_targets_remain")
