extends Node2D

@onready var level = $"../Level"

func _ready() -> void:
	Player.start_menu = self
	
func start():
	print("start")
	"Unloads self"
	process_mode = PROCESS_MODE_DISABLED
	visible = false

	"Loads game engine"
	level.process_mode = Node.PROCESS_MODE_PAUSABLE
	level.visible = true	
		
func _process(delta: float) -> void:
	if Input.is_anything_pressed(): #Press any key to start
		start()
