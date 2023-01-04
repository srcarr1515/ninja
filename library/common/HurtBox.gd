extends Node2D

onready var this = get_parent()

export (int) var max_hp = 10
var hp setget set_hp, get_hp

signal took_damage(amount, attacker)
signal hp_changed(_hp)
signal is_dead

func set_hp(_hp):
	hp = _hp
	emit_signal("hp_changed", hp)
#	hp = clamp(_hp, 0, max_hp)

func get_hp():
	return hp

func _ready():
	set_hp(max_hp)

func set_disabled(is_disabled:bool):
	get_node("Area/Shape").call_deferred("set_disabled", is_disabled)

func get_hurt(amount, attacker):
	var new_hp = hp - amount
	set_hp(new_hp)
	emit_signal("took_damage", amount, attacker)
	if hp < 1:
		hp = 0
		emit_signal("is_dead")
	return hp



