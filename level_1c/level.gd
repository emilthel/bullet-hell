extends Node2D

@export var start_screen = 0

@onready var screen_index = start_screen
enum{SCREEN, TRANSITION, TUTORIAL, DEAD}
var mode = SCREEN
var transition_scene = "res://level_1c/Scenes/transition.tscn"
var screen_scene = "res://Screens/screen_0.tscn"
var screen
var new_screen
var new_screen_index
var transition
var died: bool = false

var screen_names: Array = ["Start menu",
"Tutorial", 
"Grid", 
"Wonky Grid", 
"Think Fast", 
"Rebound", 
"Stay still?", 
"Endgame", 
"The Flood", 
"Big Bullets", 
"Thank you!"]

func _ready() -> void:
	var screen_scene = "res://Screens/" + screen_names[screen_index] + ".tscn" #Finds screen
	screen = load(screen_scene).instantiate() #Loads screen scene
	add_child(screen) #Adds screen as child
	Player.level = self

func die():
	#Unloads screen
	screen.queue_free()

	#Loads transition
	transition = load(transition_scene).instantiate()
	add_child(transition)

	mode = TRANSITION
func advance():	
	"If entering transition after completing screen"
	if mode == SCREEN: 
		#Unloads screen
		screen.queue_free()
	
		#Loads transition
		transition = load(transition_scene).instantiate()
		add_child(transition)

		mode = TRANSITION
		Player.on_screen_entered()
		screen_index += 1
		return
	
				
	"If entering screen"
	if mode == TRANSITION:		
		#Unloads transition
		transition.queue_free()
						
		#Loads screen
		var screen_scene = "res://Screens/" + screen_names[screen_index] + ".tscn" #Finds screen
		screen = load(screen_scene).instantiate() #Loads screen scene
		add_child(screen) #Adds screen as child
		
		mode = SCREEN
		return
	
func restart():
	get_tree().reload_current_scene()
