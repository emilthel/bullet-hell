extends Area2D

@onready var target = $Target
var d: Dictionary = {}
var bullets = [] 
var enemy_scene = "res://Scenes/enemy.tscn"
@export var spawn_cooldown: float = 1. / 2 
var spawn_cooldown_left: float = spawn_cooldown
@export var bullet_count: int = 5
const ONE = Vector2(1,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.global_time_speed
	"Movement: Tracks player"
	target.global_position = Player.global_position
	
	"Spawns bullets"
	spawn_cooldown_left -= delta
	if spawn_cooldown_left <= 0:
		#Resets cooldown
		spawn_cooldown_left = spawn_cooldown 
		print("spawn attempt")
		for n in range(0,bullet_count):
			#Spawns bullet
			var bullet = load(enemy_scene).instantiate()
			add_child(bullet)
			bullets.append(bullet)
			
			"Custom variables"
			d[bullet] = {}
			d[bullet]["angle"] = randf_range(0,TAU)
			d[bullet]["speed"] = -100
			d[bullet]["state"] = "sleep"
			d[bullet]["sleep_time"] = 2
			d[bullet]["target_pos"] = target.position
			
			"Starting variables"
			bullet.velocity = ONE.rotated(d[bullet]["angle"])*d[bullet]["speed"]
			bullet.modulate.a = 0.4
			bullet.collision_layer = 0
			var radius = 500
			bullet.position = ONE.rotated(d[bullet]["angle"])*radius + target.position
	
	
	"Controls bullets"
	for bullet in bullets:
		var custom = d[bullet]
		match custom["state"]:
			"sleep":
				"Movement - exponential"
				bullet.velocity += bullet.velocity * delta
								
				"Sleeping"
				custom["sleep_time"] -= delta
				
				"Enter wake state"
				if custom["sleep_time"] < 0: #Waking
					custom["state"] = "wake"
					bullet.modulate.a = 1
					bullet.collision_layer = 2
			
			"wake":
				"Movement - constant"
				bullet.velocity = ONE.rotated(custom["angle"])*custom["speed"]
						
				"Despawning"
				var distance = (custom["target_pos"] - bullet.position).length()
				print("Distance: ", distance)
				if distance < 10:
					print("despawn_attempt")
					bullet.queue_free()
					bullets.erase(bullet)
