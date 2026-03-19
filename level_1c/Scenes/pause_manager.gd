extends Node
#
#
#@onready var pause_menu_scene = "res://level_1c/Scenes/pause_menu.tscn"
#@onready var unpause_goal = $UnpauseGoal
#@onready var indicator_scene = "res://level_1c/Scenes/indicator.tscn"
#var can_unpause: bool = true
#var state = RUN
#enum{RUN, PAUSED, PAUSE_LOCK}
#
#var pause_menu
#var indicator
#var mouse_in_indicator: bool = true
#@export var can_pause: bool = false
#
#func _process(delta: float) -> void:
	#match state:
		#PAUSED:
			#"Unpause attempt"
			#if Input.is_action_just_pressed("pause"):
				#if mouse_in_indicator:
					#enter_run_state()
				#else:
					#enter_pause_lock_state()
			#
			#if mouse_in_indicator == true:
				#indicator.modulate.a = 1
			#if not mouse_in_indicator == true:
				#indicator.modulate.a = 0.9
			##print(state, mouse_in_indicator, indicator.modulate.a)
		#RUN:
			#"Pausing"
			#if Input.is_action_just_pressed("pause"):
				#if can_unpause:
					#enter_paused_state()
				#else:
					#enter_pause_lock_state()
		#PAUSE_LOCK:
			#if mouse_in_indicator:
				#enter_run_state()
#
##State change functions############################################
#func enter_run_state():
	#state = RUN
	#get_tree().paused = false
	#
	#"Removes pause menu"
	#pause_menu.queue_free()
	#if indicator:
		#indicator.queue_free()
	#
	#"Hides mouse"
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	#
	#print("enter_run_state")
#func enter_paused_state():	
	#state = PAUSED
	#get_tree().paused = true
	#
	#"Adds pause menu"
	#pause_menu = load(pause_menu_scene).instantiate()
	#add_child(pause_menu)
	#indicator = load(indicator_scene).instantiate()
	#add_child(indicator)
	##indicator.global_position = Player.global_position
	#indicator.pause_manager = self
	#indicator.scale *= 4
	#
	#"Shows mouse"
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	#
	#print("enter_paused_state")
#func enter_pause_lock_state():
	#state = PAUSE_LOCK
	#indicator.modulate = Color(1,1,0,1)
	#
	#print("enter_pause_lock_state")
	#
	#
##Misc functions####################################################
##Mouse exits indicator
#func indicator_mouse_exited():
	#mouse_in_indicator = false
#
##Mouse enters indicator
#func indicator_mouse_entered():
	#mouse_in_indicator = true
	#
