extends Area2D
var pause_manager

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
	
func _on_mouse_entered() -> void:
	pause_manager.indicator_mouse_entered()
	print("indicator says mouse entered")

func _on_mouse_exited() -> void:
	pause_manager.indicator_mouse_exited()
	print("indicator says mouse exited")
