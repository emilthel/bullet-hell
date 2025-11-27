extends Area2D

@export var velocity: Vector2 = Vector2(0,0)
@export var damage: float = 0.4

func _process(delta: float) -> void:
	position += velocity *  delta
