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

	
"Initialization"
func _frame1() -> void:
	player = Player
		
	"Generates grid"
	position = player.global_position #Sets player as center of grid
	
	var grid_range = range(-count,count+1)
	for xn in grid_range:
		for yn in grid_range:
			spawn_child(xn,yn)
	
	"Generates hole in grid"
	grid[[0,0]].queue_free()

"Process"
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed 
	if is_frame1:
		_frame1()
		is_frame1 = false

	"Scale: Changes proportional to current value rotated 90 degrees"
	var scale_rate = Vector2(-scale.y, scale.x)
	scale += scale_rate*distortion_speed*delta
	
	"Rotation"
	rotation += rotation_speed * delta

"Chooses random element of array"
func choice(a: Array):
	return a[randi() % len(a)]

"Spawns enemy in grid"
func spawn_child(xn: int, yn: int, scene = enemy_scene):
	var child = scene.instantiate() 
	
	"Sets child variables"
	child.position = Vector2(xn,yn)*spacing #Sets enemy position
	child.velocity = Vector2(0,0) #Makes enemy still
	child.scale *= 0.9 
	if scene == enemy_scene: #Always true
		child.damage = damage
	
	"Indexes child"
	grid[[xn,yn]] = child
	"Adds child"
	add_child(child)	
	return child
