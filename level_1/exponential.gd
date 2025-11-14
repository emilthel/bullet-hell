extends Area2D

@export var damage: float = 0.4
@export var velocity: Vector2 = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity*delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
