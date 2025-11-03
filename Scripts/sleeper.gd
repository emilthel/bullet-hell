extends Area2D
class_name Sleeper

@export var velocity = Vector2(0,0)

@onready var sprite = $Sprite2D

func activate():
	collision_layer = 2
	modulate = Color(10,0,0,10)
	
func _ready():
	pass
	
func _process(delta: float) -> void:		
	position += velocity
