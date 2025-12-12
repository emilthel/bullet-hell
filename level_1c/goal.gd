extends Area2D

@export var velocity: Vector2 = Vector2(100,100)
@export var heal: float = 0.2
enum{SCREEN_CHANGE, SCRIPT, NONE}
@export var mode = 0
var on_collected = Callable(on_collected_script)

func _ready() -> void:
	print("Goal spawned")
	
#For SCRIPT mode
func on_collected_script():
	print("Collected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity*delta
	
