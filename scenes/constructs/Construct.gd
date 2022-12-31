extends KinematicBody2D
class_name Construct

onready var anim_player = $AnimationPlayer
onready var detectbox = $DetectBox
onready var fsm = $StateMachine
onready var hurtbox = $HurtBox
onready var hitbox = $HitBox
onready var health_bar = $HealthBar
onready var soft_collision = $SoftCollision

export (String, "player", "enemies") var target_group = "enemies"
export (String, "player", "enemy") var user_type = "player"

var velocity

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
		fsm.change_to("Dead")

func _physics_process(delta):
	if fsm.state.name != "Dead":
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * delta * 100
		else:
			velocity = Vector2.ZERO
		velocity = move_and_slide(velocity)
