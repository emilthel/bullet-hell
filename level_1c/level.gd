extends Node2D

@export var start_screen = 1

@onready var screen_index = start_screen
enum{TO_TRANSITION, TO_SCREEN}
var mode = TO_SCREEN
var transition_scene = "res://level_1c/Scenes/transition.tscn"

var screen
var transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_name = "Screen" + str(screen_index)
	screen = get_node(screen_name)
	
	#transition = load(transition_scene).instantiate()
	#add_child(transition)

	print(screen_name)
	Player.level = self
	
func next_screen():	
	print("Screen transition attempt")
	"If entering transition"
	if mode == TO_TRANSITION: 
		#Unloads current screen
		screen.process_mode = Node.PROCESS_MODE_DISABLED
		screen.visible = false

		#Loads transition
		transition = load(transition_scene).instantiate()
		mode = TO_SCREEN
		
	"If entering screen"
	if mode == TO_SCREEN:		
		"Finds next screen"
		var screen2_index = screen_index + 1
		var screen2_name = "Screen" + str(screen2_index)
		var screen2 = get_node(screen2_name)
		
		"If next screen exists:"
		if screen2:
			#Unloads transition
			transition.queue_free()

			#Switches screen
			screen = screen2
			screen_index = screen2_index
			
			#Loads new screen
			screen.process_mode = Node.PROCESS_MODE_INHERIT
			screen.visible = true
		else:
			print("Screen transition failed")
			
	
