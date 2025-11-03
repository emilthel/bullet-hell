extends Area2D

@export var velocity = Vector2(1,0)
@export var period: float = 1
@export var radius = 100
@export var angle = 0
@export var detect_position = true
var player

func _ready() -> void:
	if detect_position:
		radius = position.length()
		angle = position.angle()
	player = get_node("/root/Engine/Player")


func _process(delta: float) -> void:
	angle += 2*PI/period * delta
	position = Vector2(radius,0).rotated(angle)	
