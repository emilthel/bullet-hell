extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1b/scenes/enemy.tscn")
var log: Array = []
var log_length: int = 100
var grid: Dictionary = {}
var is_frame1 = true
var player

@export var damage = 0.4

"Runs on first frame active"
func _frame1() -> void:
	player = $"../../Player"
	position = player.global_position
	for xn in range(-5,5):
		for yn in range(-5,5):
			var child = enemy_scene.instantiate()
			child.position = Vector2(xn,yn)*100
			child.velocity = Vector2(0,0)
			grid[[xn,yn]] = child
			add_child(child)
	grid[[0,0]].queue_free()
	
	for n in range(log_length):
		log.append(player.global_position)
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false
	log.append(player.global_position)
	velocity = log[1]-log[0]
	log.remove_at(0)
	position += velocity
