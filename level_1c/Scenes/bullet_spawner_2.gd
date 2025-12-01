extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1c/scenes/enemy.tscn")
var children: Array = []
@export var safe_radius: float = 500
@export var bullet_speed: float = 100 #Starting speed
@export var bullet_count: int = 100
@export var acceleration_mode: String = "lin"
@export var bullet_acceleration: float = 10
@export var center_delete: bool = true
@export var wait_time = 2
var state = CHARGING
var time_left = 1

enum{CHARGING, FIRING}

var is_frame1 = true
var player
var level
var screen_rect
var sprite
var sprite2
var spawn_timer

func spawn_child(point, parent = self):
	var child = enemy_scene.instantiate()
	parent.add_child(child)
	child.global_position = point
	child.velocity *= 0
	child.scale *= 0.5
	children.append(child)
	return child
	
func _random_point():
	var x = randf_range(0, screen_rect.size.x)
	var y = randf_range(0, screen_rect.size.y)
	return Vector2(x,y)
				
"Increases vector's length by x"
func _add_length(old_vector: Vector2 ,x: float):
	var old_length = old_vector.length()
	var old_angle = old_vector.angle()
	var new_vector = Vector2((old_length + x), 0).rotated(old_angle)
	return new_vector

func _spawn_bullets():
	var successful_spawns: int = 0
	while successful_spawns < bullet_count:
		var spawn_point = _random_point()			
		var bullet = spawn_child(spawn_point)
		
		var direction = -bullet.position.normalized()
		bullet.velocity = direction*bullet_speed
		
		#Skips if bullet in safe radius
		if (spawn_point - position).length() < safe_radius:
			bullet.queue_free()
			children.erase(bullet)
		else:
			successful_spawns += 1 
			




"Runs on first frame active"
func _frame1() -> void:
	player = $"../../Player"
	sprite = $CompositeSprite
	spawn_timer = $SpawnTimer
	screen_rect = get_viewport_rect()
	#position = player.position
	position = Vector2(500,500)
	sprite.scale *= float(safe_radius)/500
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false
		
	match state:
		CHARGING:
			time_left -= delta
			sprite.modulate.a = (1-time_left)*0.4
			position = player.position
			if time_left < 0:
				_spawn_bullets()
				state = FIRING
				sprite.modulate.a = 0
				screen_rect.add_child(duplicate())
				
		FIRING:
			for bullet in children:
				var distance = bullet.position.length()
				#bullet.velocity *= 100**delta
				match acceleration_mode:
					"lin":
						bullet.velocity += bullet_acceleration * bullet.velocity.normalized() * delta
					"exp":
						bullet.velocity *= bullet_acceleration ** delta
						
		 		#Deletes bullets that reach center
				if center_delete:
					if bullet.position.length() < 30:
						bullet.queue_free()
						children.erase(bullet)
		
