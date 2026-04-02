extends Area2D
enum{TO_SPAWN, TO_ACTIVATE}

var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1c/scenes/enemy.tscn")
var bullets: Array = []
var directions: Dictionary = {}
var state = TO_SPAWN

@export var safe_radius: float = 500
@export var bullet_speed: float = 100 #Starting speed
@export var bullet_count: int = 100
@export var acceleration_mode: String = "lin"
@export var lin_acc: float = 10
@export var exp_base: float = 10
@export var rot_angle: float = 0
@export var despawns: bool = false
@export var bullet_size: float = 1
@export var center_delete: bool = true
@export var spawn_time: float = 2
@export var activation_time: float = 0.2
@export var one_shot: bool = true
@export var angle_offset: float = 0

@onready var player = Player
@onready var spawn_timer = $SpawnTimer
@onready var screen = $".."
@onready var target = $Target
@onready var level = $"../.."
@onready var screen_rect = get_viewport_rect()
@onready var spawn_time_left = spawn_time/2
@onready var activation_time_left = activation_time


func _ready() -> void:
	target.scale *= float(safe_radius)/500
	position = Vector2(500,500)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed #Syncs time speed
	target.global_position = player.position #Tracks player position
	
	print("state: ", state)
	match state:
		TO_ACTIVATE: #After bullets spawned, activates after cooldown
			"Runs bullets remotely"
			run_bullets(delta)
			
			"Activation cooldown"
			activation_time_left -= delta

			"Activates newly spawned bullets"
			if activation_time_left < 0:
				activate_bullets()
				if not one_shot:
					enter_to_spawn_state()
				
		  
		TO_SPAWN:
			"Runs bullets remotely"
			run_bullets(delta)
			
			"Spawn cooldown"
			spawn_time_left -= delta

			print(spawn_time_left)
			"Spawns bullets and resets cooldown"
			if spawn_time_left < 0:
				spawn_bullets()
				enter_to_activate_state()


#State change functions
func enter_to_spawn_state():
	spawn_time_left = spawn_time #Resets cooldown
	state = TO_SPAWN
func enter_to_activate_state():
	activation_time_left = activation_time #Resets cooldown
	state = TO_ACTIVATE
	
#Misc functions
"Runs bullets remotely"
func run_bullets(delta):
	for bullet in bullets:
		if is_instance_valid(bullet): #Controls bullets that exist
			var distance = (bullet.global_position-target.global_position).length()
			match acceleration_mode:
				"lin":
					var direction = directions[bullet]
					bullet.velocity += lin_acc * direction * delta
					
					bullet.velocity = bullet.velocity.rotated(rot_angle*delta)
					direction = direction.rotated(rot_angle*delta)
					
				"exp":
					bullet.velocity *= exp_base ** delta
					bullet.velocity = bullet.velocity.rotated(rot_angle*delta)
					
	 		#Deletes bullets that reach center
			if center_delete:
				if distance < 30:
					bullet.queue_free()
		else: 	#Removes nonexistent bullets from list
			bullets.erase(bullet)
			
"Gets random point"
func random_point():
	var x = randf_range(0, screen_rect.size.x)
	var y = randf_range(0, screen_rect.size.y)
	return Vector2(x,y)

"Spawns single sprite."
func spawn_child(point, parent = self):
	var child = enemy_scene.instantiate()
	parent.add_child(child)
	child.global_position = point
	child.velocity *= 0
	child.scale *= 0.5
	child.despawns = despawns
	bullets.append(child)
	return child

"Spawns inactive bullets"
func spawn_bullets():
	var successful_spawns: int = 0
	while successful_spawns < bullet_count:
		var spawn_point = random_point()			
		var bullet = spawn_child(spawn_point)
		
		var offset = randf_range(-angle_offset, angle_offset) 
		var direction = (target.global_position-bullet.global_position).normalized().rotated(offset)
		
		"Default values"
		bullet.process_mode = Node.PROCESS_MODE_DISABLED #Bullets disabled by default
		directions[bullet] = direction
		bullet.velocity = direction*bullet_speed
		bullet.scale *= bullet_size
		bullet.modulate.a = 0.4
		
		#Skips if bullet in safe radius
		if (spawn_point - target.global_position).length() < safe_radius:
			bullet.queue_free()
			bullets.erase(bullet)
		else:
			successful_spawns += 1 
				
"Activates bullets"
func activate_bullets():
	for bullet in bullets:
		if is_instance_valid(bullet): #Controls bullets that exist
			var distance = (bullet.global_position-target.global_position).length()
			bullet.process_mode = PROCESS_MODE_INHERIT
			bullet.modulate.a = 1
	
