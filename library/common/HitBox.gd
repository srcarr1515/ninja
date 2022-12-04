extends Node2D

onready var this = get_parent()
onready var hit_area = $Area

signal on_hit(target, damage)

func _ready():
	hit_area.get_node("Shape")

func _on_Area_area_entered(area):
	var box = area.get_parent()
	if "name" in box && box.name == "HurtBox":
		if box.this != this: ## TODO: Check for ally
			var target = box.this
			var damage = 1
			if "attack_power" in this:
				damage = this.attack_power
			box.get_hurt(damage)
			emit_signal("on_hit", target, damage)
