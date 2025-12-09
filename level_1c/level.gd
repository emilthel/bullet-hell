extends Node2D

@export var start_screen = 1

@onready var screen_index = start_screen
var screen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_name = "Screen" + str(screen_index)
	screen = get_node(screen_name)

	screen.process_mode = Node.PROCESS_MODE_INHERIT
	screen.visible = true
	print(screen_name)
	Player.level = self
	
func next_screen():	
	var screen2_index = screen_index + 1
	var screen2_name = "Screen" + str(screen2_index)
	var screen2 = get_node(screen2_name)
	print(screen2_name)
	if screen2:
		#Unloads current screen
		screen.process_mode = Node.PROCESS_MODE_DISABLED
		screen.visible = false

		#Switches screen
		screen = screen2
		screen_index = screen2_index
		
		#Loads new screen
		screen.process_mode = Node.PROCESS_MODE_INHERIT
		screen.visible = true
	else:
		print("Screen transition failed")
			
	
