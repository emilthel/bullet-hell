extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1c/scenes/enemy.tscn")
var children = []
@export var free_radius = 200

var is_frame1 = true
var player
var level
var screen

func spawn_child(point):
	var child = enemy_scene.instantiate()
	add_child(child)
	child.global_position = point
	child.velocity *= 0
	child.scale *= 0.5
	children.append(child)
	return child
	
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(0, screen.size.y)
	return Vector2(x,y)
				
"Increases vector's length by x"
func _add_length(old_vector: Vector2 ,x: float):
	var old_length = old_vector.length()
	var old_angle = old_vector.angle()
	var new_vector = Vector2((old_length + x), 0).rotated(old_angle)
	return new_vector

"Runs on first frame active"
func _frame1() -> void:
	player = $"../../Player"
	level = $"../.."
	position = player.position
	screen = get_viewport_rect()
	for n in range(100):
		var spawn_point = _random_point()			
		var bullet = spawn_child(spawn_point)
		
		var direction = -bullet.position.normalized()
		bullet.velocity = direction*100
		if (spawn_point - position).length() < free_radius:
			bullet.queue_free()
			children.erase(bullet)
		print(screen)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false
	for bullet in children:
		var distance = bullet.position.length()
		bullet.velocity = _add_length(bullet.velocity, distance*0.01)
		
		#Deletes bullets that reach center
		if bullet.position.length() < 10:
			bullet.queue_free()
			children.erase(bullet)
