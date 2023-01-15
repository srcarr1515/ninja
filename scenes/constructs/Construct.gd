extends KinematicBody2D
class_name Construct

onready var anim_player = $AnimationPlayer
onready var detectbox = $DetectBox
onready var fsm = $StateMachine
onready var hurtbox = $HurtBox
onready var hitbox = $HitBox
onready var health_bar = $HealthBar
onready var soft_collision = $SoftCollision
onready var attack_state = $StateMachine/Attack
onready var buff_controller = $BuffController
onready var attack_timer = $StateMachine/Attack/Timer
var projectile_scene = "res://scenes/effects/Arrow.tscn"

export var tap_to_destroy := false
export (String) var spawn_scene_on_death
export var spawn_scene_modifier = {
	"set_scale()": [Vector2(2,2)]
}

export (String, "player", "enemies") var target_group = "enemies"
export (String, "player", "enemy") var user_type = "player"

var velocity

## Projectile mods
var proj_destroy_on_collision := true
var proj_follows_target := false

func _ready():
	var user_group = {
		"player": "player",
		"enemy": "enemies"
	}
	add_to_group(user_group[user_type])

func _on_HurtBox_took_damage(amount, attacker):
	if fsm.state.name == "Dead":
		return
	if hurtbox.hp > 0:
		var perc_hp = (float(hurtbox.hp)/float(hurtbox.max_hp)) * 100
		health_bar.set_health_bar(perc_hp)
		fsm.change_to("Hurt")
	else:
		if spawn_scene_on_death:
			var death_spawn = load(spawn_scene_on_death).instance()
			if (spawn_scene_modifier.keys()).size() > 0:
				for _attr in spawn_scene_modifier.keys():
					var _val = spawn_scene_modifier[_attr]
					if _attr[_attr.length() - 1] == ')':
						## Is a method call...
						var method_call = _attr.split("(")[0]
						death_spawn.callv(method_call, _val)
					death_spawn.set(_attr, _val)
			death_spawn.global_position = global_position
			get_tree().get_root().add_child(death_spawn)
		fsm.change_to("Dead")

func _physics_process(delta):
	if fsm.state.name != "Dead":
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * delta * 100
		else:
			velocity = Vector2.ZERO
		velocity = move_and_slide(velocity)

func _on_TapArea_released():
	if tap_to_destroy:
		hurtbox.hp = 0
		_on_HurtBox_took_damage(1, null)
		
	
