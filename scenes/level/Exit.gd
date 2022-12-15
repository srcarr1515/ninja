extends StaticBody2D

onready var hurtbox = $HurtBox
onready var anim_player = $AnimationPlayer
var is_open = false

func _ready():
	yield(get_tree(), "idle_frame")
	GameData.exit_hp_label.text = "Exit HP: {hp}".format({"hp": hurtbox.hp})
	GameData.level_exit = self

func _on_HurtBox_took_damage(amount):
	if hurtbox.hp >= 0 && !is_open:
		GameData.exit_hp_label.text = "Exit HP: {hp}".format({"hp": hurtbox.hp})
	elif !is_open:
		GameData.exit_hp_label.text = "Exit HP: {hp}".format({"hp": 0})
		anim_player.play("open")
		is_open = true
