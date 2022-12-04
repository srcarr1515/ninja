extends Node

class_name StateMachine

export (bool) var DEBUG = false

var state: Object
var this

var history = []

func _ready():
	this = get_parent()
	# Set the initial state to the first child node
	if get_child_count() > 0:
		state = get_child(0)
		state.fsm = self
		state.this = this
		_enter_state()

func change_to(new_state):
	var next_state = get_node(new_state)
	if next_state != null:
		if state == next_state:
			return
		next_state.fsm = self
		next_state.this = this
		if state != null:
			history.append(state.name)
		state = next_state
		_enter_state()

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()

func _enter_state():
	if DEBUG:
		print("Entering state: ", state.name)
	# Give the new state a reference to this state machine script
	state.enter()

func activate_state(state_method, method_params=null):
	if "status" in this && this.status == "Dead":
		change_to("Dead")
	else:
		if state && state.has_method(state_method):
			if method_params != null:
				state.call_deferred(state_method, method_params)
			else:
				state.call_deferred(state_method)

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	activate_state("process", delta)

func _physics_process(delta):
	activate_state("physics_process", delta)

func _input(event):
	activate_state("input", event)

func _unhandled_input(event):
	activate_state("unhandled_input", event)

func _unhandled_key_input(event):
	activate_state("unhandled_key_input", event)
