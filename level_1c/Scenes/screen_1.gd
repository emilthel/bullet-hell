extends Node2D

@onready var goal = $Goal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.mode = goal.SCREEN_CHANGE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
