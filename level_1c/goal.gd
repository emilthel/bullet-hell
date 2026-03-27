extends Area2D

@export var velocity: Vector2 = Vector2(100,100)
@export var ignores_invincibility: bool = false
@export var custom_heal = false
@export var heal: float = 0.1
enum{SCREEN_CHANGE, SCRIPT, NONE}
@export var mode = 0

var on_collected = Callable(on_collected_script)

"Process"
func _process(delta: float) -> void:
	pass

"#For SCRIPT mode"
func on_collected_script():
	pass
	
