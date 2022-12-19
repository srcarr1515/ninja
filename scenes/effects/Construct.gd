extends KinematicBody2D
var tap_path

func _on_TouchScreenButton_pressed():
	print("touched!")

func _on_TouchScreenButton_released():
	print("released!")
