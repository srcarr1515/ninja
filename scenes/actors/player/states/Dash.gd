extends State

export (PackedScene) var dash_skill
var dash_skill_instance
var dash_speed = 1200
var movement_type = "dash"
var input_dir = Vector2.ZERO

## DASH
func enter():
	this.hurtbox.get_node("Area/Shape").set_disabled(true)
	this.hitbox.get_node("Area/Shape").set_disabled(false)
	input_dir = this.input_dir
	if dash_skill:
		dash_skill_instance = dash_skill.instance()
		if dash_skill_instance.player_movement_type:
			movement_type = dash_skill_instance.player_movement_type
		if dash_skill_instance.dash_speed:
			dash_speed = dash_skill_instance.dash_speed
		this.add_child(dash_skill_instance)

func physics_process(delta):
	if this.input_dir:
		if movement_type == "dash":
			this.velocity = this.position.direction_to(this.position + this.input_dir) * dash_speed
			this.velocity = this.move_and_slide(this.velocity)
	if movement_type == "bullet" && is_instance_valid(dash_skill_instance):
		if dash_skill_instance.player_animation:
			if this.anim_player.has_animation(dash_skill_instance.player_animation):
				this.anim_player.play(dash_skill_instance.player_animation)
		this.velocity = input_dir * dash_speed
		this.move_and_slide(this.velocity)
	if !is_instance_valid(dash_skill_instance):
		dash_skill_instance = null
		this.anim_player.play("Idle")
		exit("Idle")

func on_exit():
	yield(get_tree().create_timer(0.05), "timeout")
	this.hitbox.get_node("Area/Shape").set_disabled(true)
	this.hurtbox.get_node("Area/Shape").set_disabled(false)
	if dash_skill_instance && is_instance_valid(dash_skill_instance):
		dash_skill_instance.queue_free()
