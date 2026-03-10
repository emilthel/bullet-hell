extends Area2D

@onready var target = $Target
var d: Dictionary = {}
var bullets = [] 
var enemy_scene = "res://level_1c/Scenes/enemy.tscn"
var spawn_cooldown: float = 0.2
var spawn_cooldown_left: float = spawn_cooldown
var bullet_count: int = 3
const ONE = Vector2(1,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	"Movement: Tracks player"
	target.position = Player.global_position
	
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
			
			"Starting variables"
			bullet.velocity = Vector2(0,0)
			var angle = randf_range(0,TAU)
			var radius = 300
			bullet.position = ONE.rotated(angle)*radius + target.position
			
			"Custom variables"
			d[bullet] = {}
			d[bullet]["angle"] = angle
			d[bullet]["speed"] = -100
		
		
	"Controls bullets"
	for bullet in bullets:
		var custom = d[bullet]
		bullet.velocity = ONE.rotated(custom["angle"])*custom["speed"]
	
		
		
		
		
