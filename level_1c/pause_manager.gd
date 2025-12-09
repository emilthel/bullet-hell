extends Node

@onready var level = $Level

func _ready():
	get_tree().paused = true
	
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		print(get_tree().paused)
		
