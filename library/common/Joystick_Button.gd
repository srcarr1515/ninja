extends TouchScreenButton

var radius = Vector2(20,20)
var boundary = 64


var ongoing_drag = -1
var return_accel = 20
var threshold = 10

func _ready():
	get_parent().visible = false
	GameData.joystick = get_parent()

func get_button_pos():
	return position + radius

func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0,0) - radius) - position
		position += pos_difference * return_accel * delta

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		var joystick = get_parent()
		joystick.global_position = event.position
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - get_parent().global_position).length()
		if event_dist_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
			if get_button_pos().length() > boundary:
				set_position(get_button_pos().normalized() * boundary - radius)
			ongoing_drag = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		
func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()

