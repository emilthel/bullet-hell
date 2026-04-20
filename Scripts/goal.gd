extends Area2D

@export var velocity: Vector2 = Vector2(100,100)
@export var ignores_invincibility: bool = true
enum{SCREEN_CHANGE, SCRIPT, NONE}
@export var mode = 0

var on_collected: Callable #Script to run on collected, for SCRIPT mode

"Process"
func _process(delta: float) -> void:
	pass

	
