extends Node2D

#@onready var screensize = get_viewport().get_visible_rect().size
#@onready var mouse_entered_screen: bool = false

var to_pause = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	 
	
#func _mouse_on_screen() -> bool:
	#var mouse_pos = get_global_mouse_position()
	#if mouse_pos.x > 0 and mouse_pos.x < screensize.x:
		#if mouse_pos.y > 0 and mouse_pos.y < screensize.y:
			#return true
		#else:
			#return false
	#else:
		#return false
	#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if not mouse_entered_screen:
		#if _mouse_on_screen():
			#print("mouse on screen")
			#get_tree().paused = false
			#mouse_entered_screen = true
	
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		
	if Input.is_action_just_pressed("frame advance"):
		get_tree().paused = false
		print("frame advance")
