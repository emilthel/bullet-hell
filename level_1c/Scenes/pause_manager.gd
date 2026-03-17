extends Node


@onready var pause_menu_scene = "res://level_1c/Scenes/pause_menu.tscn"
@onready var unpause_goal = $UnpauseGoal
var pause_menu
var is_paused: bool = false
var can_unpause: bool = true
@export var can_pause: bool = false

func _process(delta: float) -> void:				
	unpause_goal.global_position = Player.global_position
	if pause_menu:
		if can_unpause:
			print("can unpause")
	if Input.is_action_just_pressed("pause") and can_pause:
		print("pause attempt")
		match is_paused:
			false: #Pausing
				get_tree().paused = true
				is_paused = true
				print("pausing")
				pause_menu = load(pause_menu_scene).instantiate()
				print(pause_menu)
				add_child(pause_menu)
				
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
			true: #Unpausing
				if can_unpause:
					get_tree().paused = false
					is_paused = false
					print("unpausing")
					pause_menu.queue_free()
					Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
					


func _on_unpause_goal_mouse_exited() -> void:
	can_unpause = false
	
func _on_unpause_goal_mouse_entered() -> void:
	can_unpause = true
