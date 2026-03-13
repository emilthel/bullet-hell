extends Node


@onready var pause_menu_scene = "res://level_1c/Scenes/pause_menu.tscn"
var pause_menu
var is_paused: bool = false
@export var can_pause: bool = false

func _process(delta: float) -> void:
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
				
			true: #Unpausing
				get_tree().paused = false
				is_paused = false
				print("unpausing")
				pause_menu.queue_free()
