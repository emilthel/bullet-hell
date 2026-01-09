extends Node2D

@export var start_screen = 0

@onready var screen_index = start_screen
enum{TO_TRANSITION, TO_SCREEN}
var mode = TO_SCREEN
var transition_scene = "res://level_1c/Scenes/transition.tscn"
var screen
@onready var transition  = $Transition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_name = "Screen" + str(screen_index)
	screen = get_node(screen_name)
	
	#transition = load(transition_scene).instantiate()
	#add_child(transition)
	Player.level = self
	
func next_screen():	
	"If entering transition"
	if mode == TO_TRANSITION: 
		#Unloads current screen
		screen.process_mode = Node.PROCESS_MODE_DISABLED
		screen.visible = false

		#Loads transition
		transition = load(transition_scene).instantiate()
		add_child(transition)
		mode = TO_SCREEN
		
		#Changes displayed screen number
		Player.screen_counter.text = str(screen_index+1)

		return

		
	"If entering screen"
	if mode == TO_SCREEN:		
		"Finds next screen"
		var new_screen_index = screen_index + 1
		var new_screen_name = "Screen" + str(new_screen_index)
		var new_screen = get_node(new_screen_name)			
		"If next screen exists:"
		if new_screen:
			#Unloads transition
			transition.queue_free()

			#Switches screen
			screen = new_screen
			screen_index = new_screen_index
			
			#Loads new screen
			screen.process_mode = Node.PROCESS_MODE_INHERIT
			screen.visible = true
			
			print(screen.name)

			mode = TO_TRANSITION
			return
		else:
			print("Screen transition failed")
			
			
	
