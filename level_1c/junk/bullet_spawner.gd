extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1c/scenes/enemy.tscn")

var is_frame1 = true
var player
var level
var screen

func spawn_child(point, speed=100):
	var child = enemy_scene.instantiate()
	add_child(child)
	child.global_position = point
	var direction = (position - child.global_position).normalized()
	child.velocity = direction*speed
	child.scale *= 0.5
	return child
	
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(0, screen.size.y)
	return Vector2(x,y)
				
"Runs on first frame active"
func _frame1() -> void:
	player = Player
	level = $"../.."
	position = player.position
	screen = get_viewport_rect()
	spawn_child(Vector2(200,500), 400)
	for n in range(100):
		var spawn_point = _random_point()			
		var bullet = spawn_child(spawn_point, 100)
		if (spawn_point - position).length() < 200:
			bullet.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	if is_frame1:
		_frame1()
		is_frame1 = false
