extends Node2D

onready var this = get_parent()
onready var hit_area = $Area
export var attack_power = 1
onready var timer = $Timer

var life_leech_percent := 100
export var life_leech_perc := 0

signal on_hit(target, damage)

func _ready():
	hit_area.get_node("Shape")

func set_disabled(is_disabled:bool):
	get_node("Area/Shape").call_deferred("set_disabled", is_disabled)

func _on_Area_area_entered(area):
	deal_damage(area)

func deal_damage(area):
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
			## Life Leech
			if life_leech_perc > 0:
				print('should leech')
				var hurtbox = this.get_node_or_null("HurtBox")
				if hurtbox:
					var hp_stolen = damage * (life_leech_perc * 0.01)
					print("leeching: ", hp_stolen, " ", life_leech_perc, " ", (life_leech_perc * 0.01))
					## Is triggering twice? Need to check into that.
					hurtbox.hp += hp_stolen

func _on_Timer_timeout():
	for area in hit_area.get_overlapping_areas():
		deal_damage(area)
