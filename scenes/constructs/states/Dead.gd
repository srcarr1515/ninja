extends State

func enter():
	this.visible = false
	this.hurtbox.set_disabled(true)
	this.detectbox.set_disabled(true)


func _on_Timer_timeout():
	this.queue_free()
