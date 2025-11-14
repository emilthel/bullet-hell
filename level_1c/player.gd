extends Area2D

@export var blood: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	


func _on_area_entered(area: Area2D) -> void:
	blood -= 0.4
	if blood <= 0:
		get_tree().quit()
