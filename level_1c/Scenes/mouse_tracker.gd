extends Node2D

var old_pos: Vector2
var mouse_difference: Vector2
func _ready() -> void:
	global_position = get_global_mouse_position() #New position
	mouse_difference = global_position - old_pos #Computes difference
	old_pos = global_position #Memorizes position
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position() #New position
	mouse_difference = global_position - old_pos #Computes difference
	old_pos = global_position #Memorizes position

	print(mouse_difference)
