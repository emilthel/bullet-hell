extends Node2D

@onready var goal = $Goal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.mode = 1
	goal.on_collected_script = Callable(on_collected_script
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_collected_script():
	Player.on_start_menu_exited()
