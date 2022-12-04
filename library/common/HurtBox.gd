extends Node2D

onready var this = get_parent()

export (int) var max_hp = 10
onready var hp = max_hp

signal took_damage(amount)
signal is_dead

func get_hurt(amount):
	hp -= amount
	emit_signal("took_damage", amount)
	if hp < 1:
		hp = 0
		emit_signal("is_dead")
	return hp



