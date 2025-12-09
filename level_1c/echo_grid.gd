extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1b/scenes/enemy.tscn")
var goal_scene: PackedScene = load("res://level_1c/Scenes/goal.tscn")
var log: Array = []
var grid: Dictionary = {}
var is_frame1 = true
var player

@export var log_length: int = 100
@export var count: int = 3
@export var damage = 0.4
@export var angle: float = 0
@export var factor: float = 1
@export var spacing: float = 100

func choice(a: Array):
	return a[randi() % len(a)]

func spawn_child(xn: int, yn: int, scene = enemy_scene):
	var child = scene.instantiate()
	child.position = Vector2(xn,yn)*spacing
	child.velocity = Vector2(0,0)
	child.scale *= 0.9
	if scene == enemy_scene:
		child.damage = damage
	grid[[xn,yn]] = child
	add_child(child)
	return child
	
"Runs on first frame active"
func _frame1() -> void:
	player = Player
	position = player.global_position
	var grid_range = range(-count,count+1)
	for xn in grid_range:
		for yn in grid_range:
			spawn_child(xn,yn)
		
	var xn = choice(grid_range)
	var yn = choice(grid_range)
	
	#grid[[xn,yn]].queue_free()
	spawn_child(xn,yn)

	
		#var goal = goal_scene.instantiate()
	#goal.position = Vector2(xn,yn)*100
	#goal.velocity = Vector2(0,0)
	#goal.scale *= 0.9
	#grid[[xn,yn]] = goal
	#add_child(goal)
	
	grid[[0,0]].queue_free()
	
	for n in range(log_length):
		log.append(player.global_position)
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	if is_frame1:
		_frame1()
		is_frame1 = false
	log.append(player.global_position)
	velocity = (log[1]-log[0]).rotated(angle)*factor
	log.remove_at(0)
	position += velocity
