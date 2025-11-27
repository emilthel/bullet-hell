extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1c/scenes/enemy.tscn")
var goal_scene: PackedScene = load("res://level_1c/Scenes/goal.tscn")
var log: Array = []
var grid: Dictionary = {}
var is_frame1 = true
var player

const ONE = Vector2(1,0)
const I = Vector2(0,1)

@export var log_length: int = 100
@export var count: int = 3
@export var damage = 0.4
@export var angle: float = 0
@export var factor: float = 1
@export var spacing: float = 100
@export var distortion_speed: float = 1
@export var rotation_speed: float = 1

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
	
func cpow(z: Vector2, n) -> Vector2:
	var r = z.length()
	var v = z.angle()
	
	return r**n * ONE.rotated(n*v)

func cmul(z: Vector2, w: Vector2) -> Vector2:
	var r = z.length()
	var v = z.angle()
	
	var l = w.length()
	var u = w.angle()
	
	var one = Vector2(1,0)
	return r*l * ONE.rotated(v+u)
	
"Runs on first frame active"
func _frame1() -> void:
	player = $"../../Player"
	position = player.global_position
	var grid_range = range(-count,count+1)
	for xn in grid_range:
		for yn in grid_range:
			spawn_child(xn,yn)
		
	#var xn = choice(grid_range)
	#var yn = choice(grid_range)
	
	grid[[0,0]].queue_free()
	
	#for n in range(log_length):
		#log.append(player.global_position)
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false
	#log.append(player.global_position)
	#velocity = (log[1]-log[0]).rotated(angle)*factor
	#log.remove_at(0)
	#position += velocity 
	var scale_rate = cmul(cpow(scale,1),I)
	scale += scale_rate*distortion_speed*delta
	rotation += rotation_speed*delta
