extends Node2D

var screen
var goal_scene: PackedScene = load("res://level_1c/Scenes/goal.tscn")
@onready var spawn_timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect()
	print(screen)
	spawn_child(_random_point())

func spawn_child(point, scene = goal_scene):
	var child = scene.instantiate()
	child.position = point
	child.velocity = Vector2(0,0)
	child.scale *= 0.9
	child.mode = child.NONE
	add_child(child)
	return child
	
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(0, screen.size.y)
	return Vector2(x,y)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	spawn_child(_random_point())
