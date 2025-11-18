extends Node2D

var screen
var goal_scene: PackedScene = load("res://level_1c/Scenes/goal.tscn")
@onready var spawn_timer = $SpawnTimer
var is_frame1 = true

# Called when the node enters the scene tree for the first time.
func _frame1() -> void:
	screen = get_viewport_rect()
	print(screen)
	spawn_child(_random_point())
	
	var lambda = func ():
		print("lambda")
	lambda()
	
func goal_collected():
	print("script")

func spawn_child(point):
	var goal = goal_scene.instantiate()
	goal.position = point
	goal.velocity = Vector2(0,0)
	goal.scale *= 0.9
	goal.mode = goal.SCRIPT
	goal.on_collected = Callable(goal_collected)
	add_child(goal)
	return goal
	
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(0, screen.size.y)
	return Vector2(x,y)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false

func _on_spawn_timer_timeout() -> void:
	spawn_child(_random_point())
