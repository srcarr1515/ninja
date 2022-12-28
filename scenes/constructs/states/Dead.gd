extends State
onready var timer = $Timer

func enter():
	this.visible = false
	this.hurtbox.set_disabled(true)
	this.detectbox.set_disabled(true)
	timer.start()


func _on_Timer_timeout():
	pass
