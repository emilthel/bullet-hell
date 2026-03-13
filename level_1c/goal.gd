extends Area2D

@export var velocity: Vector2 = Vector2(100,100)
enum{SCREEN_CHANGE, SCRIPT, NONE}
@export var mode = 0
var on_collected = Callable(on_collected_script)
@export var ignores_invincibility: bool = false
@export var custom_heal = false
@export var heal: float = 0.1

func _ready() -> void:
	pass	
	
#For SCRIPT mode
func on_collected_script():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
