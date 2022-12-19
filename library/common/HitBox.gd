extends Node2D

onready var this = get_parent()
onready var hit_area = $Area
export var attack_power = 1

signal on_hit(target, damage)

func _ready():
	hit_area.get_node("Shape")

func set_disabled(is_disabled:bool):
	get_node("Area/Shape").call_deferred("set_disabled", is_disabled)

func _on_Area_area_entered(area):
	var box = area.get_parent()
	if "name" in box && box.name == "HurtBox":
		if box.this != this: ## TODO: Check for ally
			var target = box.this
			var damage = attack_power
			if (this is Player || this is Enemy) && this.fsm.state.name != "Dead":
				box.get_hurt(damage, this)
				emit_signal("on_hit", target, damage)
			elif !("fsm" in this):
				box.get_hurt(damage, this)
				emit_signal("on_hit", target, damage)
