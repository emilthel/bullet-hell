extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1b/scenes/exponential.tscn")
var log: Array = [Vector2(0,0),Vector2(0,0) ]
@onready var player = $"../Player"
@export var damage = 0.4

func _ready() -> void:
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = log[1]-log[0]
	
	log.append(player.global_position)
	log.remove_at(0)
	
	position += velocity
