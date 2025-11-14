extends Node2D

@export var start_screen = 1

var screen_index = start_screen
var screen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_name = "Screen" + str(screen_index)
	screen = get_node(screen_name)

	screen.process_mode = Node.PROCESS_MODE_INHERIT
	screen.visible = true
	
func next_screen():
	print("Next screen")
	
	screen.process_mode = Node.PROCESS_MODE_DISABLED
	screen.visible = false
	screen_index += 1
		
	var screen_name = "Screen" + str(screen_index)
	screen = get_node(screen_name)

	screen.process_mode = Node.PROCESS_MODE_INHERIT
	screen.visible = true
	
	
