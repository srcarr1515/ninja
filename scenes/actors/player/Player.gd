extends KinematicBody2D

var first_touch:Vector2
var target_position:Vector2
var velocity:Vector2
export var speed:= 500
export var friction:= 0.01
export var acceleration:= 0.1
var new_angle
var cur_side

var slide_ct = 0

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			first_touch = event.position
		elif !event.is_pressed():
			new_angle = event.position.angle_to_point(first_touch)
			target_position = get_end_pos_from_start_pos_and_angle(position, new_angle, 640)
			slide_ct = 0

func get_inverted_pos(a:Vector2, b:Vector2, dist):
	return a + ((a - b).normalized()) * dist

func get_end_pos_from_start_pos_and_angle(start_pos, angle, distance):
	var x = start_pos.x + (distance * cos(angle))
	var y = start_pos.y + (distance * sin(angle))
	return Vector2(x, y)

func get_collision_side(collision_pos):
	var x = collision_pos.x - position.x
	var y = collision_pos.y - position.y
	var side
	if abs(x) > 1:
		## LEFT/RIGHT
		if x > 0:
			side = "RIGHT"
		else:
			side = "LEFT"
	else:
		## UP/DOWN
		if y > 0:
			side = "DOWN"
		else:
			side = "UP"
	return side

func _physics_process(delta):
	if target_position:
		velocity = position.direction_to(target_position) * speed
		var side = []
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			side.push_front(get_collision_side(collision.position))
		
		var can_move = false
		var vert_move = abs(new_angle) >= 1 && abs(new_angle) <= 2
		var horz_move = abs(new_angle) < 0.25 || abs(new_angle) > 3
				
		if vert_move:
			can_move = (side.has("LEFT") || side.has("RIGHT")) && is_on_wall()
		elif horz_move:
			can_move = (side.has("UP") || side.has("DOWN")) && (is_on_floor() || is_on_ceiling())
			
		if position.distance_to(target_position) >= 5 && (slide_ct == 0 || can_move):
			velocity = move_and_slide(velocity, Vector2.UP)
			slide_ct = get_slide_count()
		else:
			cur_side = side
			velocity = Vector2.ZERO
