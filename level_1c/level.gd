extends Node2D

@export var start_screen = -1

@onready var screen_index = start_screen
enum{SCREEN, TRANSITION}
var mode = TRANSITION
var tutorial_transition_scene = "res://level_1c/Scenes/tutorial_transition.tscn"
var transition_scene = "res://level_1c/Scenes/transition.tscn"
var screen
var new_screen
var new_screen_index
var transition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition = load(transition_scene).instantiate()	#Loads tutorial
	add_child(transition)
	transition.screen_counter.text = str(screen_index + 1) #Displays number of upcoming screen
	var screen_name = "Screen" + str(screen_index)
	screen = get_node(screen_name)
	
	#transition = load(transition_scene).instantiate()
	#add_child(transition)
	Player.level = self
	
func enter_transition():
	#print("Enter transition", screen_index)
	#Unloads current screen
	screen.process_mode = Node.PROCESS_MODE_DISABLED
	screen.visible = false
	
	#Loads transition
	transition = load(transition_scene).instantiate()
	add_child(transition)
	mode = TRANSITION

	#Displays screen
	transition.screen_counter.text = str(screen_index + 1) #Displays number of upcoming screen
	return transition

func get_next_screen():
	var new_screen_index = screen_index + 1
	var new_screen_name = "Screen" + str(new_screen_index)
	var new_screen = get_node(new_screen_name)	
	return new_screen
	
func next_screen():	
	"If entering transition"
	if mode == SCREEN: 
		transition = enter_transition()
		return
				
	"If entering screen"
	if mode == TRANSITION:		
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
			
			#print(screen.name)

			mode = SCREEN
			#Updates GUI
			Player.on_screen_entered()
			return
		else:
			print("Screen transition failed")
			
			
func _process(delta: float) -> void:
	pass
