extends Area2D

@export var velocity: Vector2 = Vector2(100,100)
@export var heal: float = 0.2
enum{SCREEN_CHANGE, SCRIPT, NONE}
var mode = SCREEN_CHANGE
#For SCRIPT mode
func script():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity*delta
