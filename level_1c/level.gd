extends Node2D

@export var start_screen = 0

@onready var screen_index = start_screen
enum{SCREEN, TRANSITION, TUTORIAL, DEAD}
var mode = SCREEN
var transition_scene = "res://level_1c/Scenes/transition.tscn"
var screen_scene = "res://Screens/screen_0.tscn"
var died: bool = false
var screen_names: Array = [
"Start Menu",
"Tutorial", 
"Grid", 
"Wonky Grid", 
"Think Fast", 
"Rebound",
"Stay still?", 
"Endgame", 
"Big Bullets", 
"The Flood", 
"Thank you!"]
var screen
var new_screen
var new_screen_index
var transition
var unloaded_screen
var screen_to_load = load("res://Screens/Start Menu.tscn")

func _ready() -> void:
	var screen_scene = "res://Screens/" + screen_names[screen_index] + ".tscn" #Finds screen
	screen_to_load = load(screen_scene).instantiate() #Loads screen scene
	screen = screen_to_load.duplicate()
	add_child(screen) #Adds screen as child
	Player.level = self
	
	Player.on_screen_entered()

func _process(delta: float) -> void:
	"For player slowmo"
	delta *= TimeManager.time_speed
	
"Called when player detects death"
func die():
	#Unloads screen
	screen.queue_free()

	#Loads transition
	transition = load(transition_scene).instantiate()
	add_child(transition)

	mode = TRANSITION

"On collecting collecting all goals on screen or collecting the goal in a transition"
func advance():	
	"Exit screen, enter transition"
	if mode == SCREEN: 
		#Unloads screen
		unloaded_screen = screen.duplicate() #Saves a copy of previous screen to memory
		screen.queue_free() #Removes original from game
		screen_to_load = load(find_path(screen_names[screen_index + 1])).instantiate() #Stores next screen in memory
		screen_index += 1
		
		#Loads transition
		transition = load(transition_scene).instantiate()
		add_child(transition)

		#Signals to player
		Player.on_screen_exited()
		
		#Makes goal in transition load next screen
		mode = TRANSITION
		return
	
				
	"Exit transition, enter screen"
	if mode == TRANSITION:		
		#Unloads transition
		transition.queue_free()		
		
		#Loads screen into game
		screen = screen_to_load.duplicate()
		add_child(screen)
		
		#Signals to player
		Player.on_screen_entered()
		
		mode = SCREEN
		return
	
func restart(): #For player to run game over
	get_tree().reload_current_scene()

func find_path(screen_name: String):
	return "res://Screens/" + screen_name + ".tscn"
