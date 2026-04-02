extends Area2D

@export var health: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	global_position = get_global_mouse_position()
	


func _on_area_entered(area: Area2D) -> void:
	health -= 0.4
	if health <= 0:
		get_tree().quit()
