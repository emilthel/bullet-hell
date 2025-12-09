extends Area2D

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1c/scenes/enemy.tscn")
var children: Array = []
var directions: Dictionary = {}
@export var safe_radius: float = 500
@export var bullet_speed: float = 100 #Starting speed
@export var bullet_count: int = 100
@export var acceleration_mode: String = "lin"
@export var lin_acc: float = 10
@export var exp_base: float = 10
@export var rot_angle: float = PI
@export var bullet_size: float = 1
@export var center_delete: bool = true
@export var wait_time: float = 2
@export var one_shot: bool = true
@export var angle_offset: float = 0

var state = ACTIVE 

enum{ACTIVE, SLEEP}

var is_frame1 = true
var player
var level
var screen_rect
var screen
var sprite
var sprite2
var spawn_timer
var target
var time_left
var abilities
var time_speed

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
				

func _spawn_bullets():
	var successful_spawns: int = 0
	while successful_spawns < bullet_count:
		var spawn_point = _random_point()			
		var bullet = spawn_child(spawn_point)

		var offset = randf_range(-angle_offset, angle_offset)
		var direction = (target.global_position-bullet.global_position).normalized().rotated(offset)
		directions[bullet] = direction
		bullet.velocity = direction*bullet_speed
		bullet.scale *= bullet_size

		#Skips if bullet in safe radius
		if (spawn_point - target.global_position).length() < safe_radius:
			bullet.queue_free()
			children.erase(bullet)
		else:
			successful_spawns += 1 
				




"Runs on first frame active"
func _frame1() -> void:
	player = Player
	sprite = $Target/CompositeSprite
	spawn_timer = $SpawnTimer
	screen = $".."
	target = $Target
	abilities = $"../Abilities"
	screen_rect = get_viewport_rect()
	#position = player.position
	position = Vector2(500,500)
	sprite.scale *= float(safe_radius)/500
	time_left = wait_time
	time_speed = 1
	
# Called every frame. 'time_speed*delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	if is_frame1:
		_frame1()
		is_frame1 = false
	time_speed = abilities.time_speed
	
	time_left -= time_speed*delta
	sprite.modulate.a = (1-time_left)*0.4
	target.global_position = player.position
		
	if time_left < 0:
		_spawn_bullets()
		sprite.modulate.a = 0
		if one_shot:
			time_left = INF
		else:
			time_left = wait_time

	
	for bullet in children:
		if is_instance_valid(bullet): #Runs if bullet exists
			var distance = (bullet.global_position-target.global_position).length()
			#bullet.velocity *= 100**time_speed*delta
			match acceleration_mode:
				"lin":
					var direction = directions[bullet]
					bullet.velocity += lin_acc * direction * time_speed*delta
					
					bullet.velocity = bullet.velocity.rotated(rot_angle*time_speed*delta)
					direction = direction.rotated(rot_angle*time_speed*delta)
					
				"exp":
					bullet.velocity *= exp_base ** time_speed*delta
					bullet.velocity = bullet.velocity.rotated(rot_angle*time_speed*delta)
					
	 		#Deletes bullets that reach center
			if center_delete:
				if distance < 30:
					bullet.queue_free()
		else: 	#Removes nonexistent bullets from list
			children.erase(bullet)
