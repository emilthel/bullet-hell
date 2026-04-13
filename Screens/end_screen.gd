extends Control

@onready var time_score = $TimeScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_score.text = "3"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
