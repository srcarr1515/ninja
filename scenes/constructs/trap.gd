extends StaticBody2D
class_name Trap

onready var anim_player = $AnimationPlayer

export var destructible := false
export (String, "any", "ground", "air") var target_types = "any"
export var stuns_target := false

func _on_Area_area_entered(area):
	var box = area.get_parent()
	var target = box.this
	anim_player.play("trigger")
	if target is Player || target is Enemy:
		if stuns_target:
			target.fsm.change_to("Stunned")
	yield(anim_player, "animation_finished")
	if destructible:
		queue_free()
