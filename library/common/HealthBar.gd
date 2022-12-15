extends TextureProgress

onready var timer = $Timer

func _ready():
	modulate.a = 0

func _on_Timer_timeout():
	pass # Replace with function body.

func set_health_bar(health_value):
	value = health_value
	modulate.a = 1
	timer.start()

func _process(delta):
	if timer.is_stopped() && modulate.a > 0:
		modulate.a -= 0.01
