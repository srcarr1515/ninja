extends KinematicBody2D

var first_touch:Vector2
var target_position:Vector2
var velocity:Vector2
export var speed:= 500
export var friction:= 0.01
export var acceleration:= 0.1
var new_angle

var slide_ct = 0

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			first_touch = event.position
		elif !event.is_pressed():
			new_angle = event.position.angle_to_point(first_touch)
			target_position = get_end_pos_from_start_pos_and_angle(position, new_angle, 640)
			slide_ct = 0
			print(new_angle)
			

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
			print(side)
		var can_move = false
		if new_angle:
			if (side.has("LEFT") || side.has("RIGHT")) && abs(new_angle) < 1 || abs(new_angle) > 3:
				can_move = false
			elif (side.has("UP") || side.has("DOWN")) && abs(new_angle) >= 1 && abs(new_angle) <= 2:
				can_move = false
			if (side.has("LEFT") || side.has("RIGHT")) && abs(new_angle) >= 1 && abs(new_angle) <= 2:
				can_move = true
				if (side.has("UP") || side.has("DOWN")) && abs(new_angle) >= 1 && abs(new_angle) <= 2:
					can_move = true
			elif (side.has("UP") || side.has("DOWN")) && abs(new_angle) < 1 || abs(new_angle) > 3:
				can_move = true
				if (side.has("LEFT") || side.has("RIGHT")) && abs(new_angle) >= 1 && abs(new_angle) <= 2:
					can_move = true
#		print(side)
		if position.distance_to(target_position) >= 5 && (slide_ct == 0 || can_move):
			velocity = move_and_slide(velocity)
			slide_ct = get_slide_count()

#		if new_angle:
#			if (side.has("LEFT") || side.has("RIGHT")) && abs(new_angle) < 1 || abs(new_angle) > 3:
#				can_move = false
#			elif (side.has("UP") || side.has("DOWN")) && abs(new_angle) >= 1 && abs(new_angle) <= 2:
#				can_move = false
#			elif (side.has("LEFT") || side.has("RIGHT")) && abs(new_angle) >= 1 && abs(new_angle) <= 2:
#				can_move = true
#			elif (side.has("UP") || side.has("DOWN")) && abs(new_angle) < 1 || abs(new_angle) > 3:
#				can_move = true	
