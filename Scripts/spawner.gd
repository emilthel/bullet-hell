extends Area2D

@export var velocity = Vector2(0,0)

@onready var sprite = $Sprite2D
@onready var spawn_timer = $SpawnTimer
var child_scene = load("res://Scenes/stalker.tscn")


func _ready():
	spawn_timer.start()
	
func _process(float) -> void:
	position += velocity
	sprite.self_modulate = self_modulate


func _on_spawn_timer_timeout() -> void:
	var child = child_scene.new()
	add_child(child.scene)
