extends Area2D


var enemy_scene = "res://level_1c/Scenes/enemy_dummy.tscn"
var cooldown = 0.1
var cooldown_left = cooldown
var bullets: Array = []
var props: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed

	"Spawns bullets on cooldown"
	cooldown_left -= delta
	if cooldown_left < 0:
		cooldown_left = cooldown
		
		var bullet = load(enemy_scene).instantiate()
		add_child(bullet)
		bullets.append(bullet)
		
		bullet.position = _generate_start_position()

		"Starting values"		
		var local_properties = {}
		props[bullet] = local_properties
		props[bullet]["time"] = 0
		props[bullet]["state"] = "off"
		var v = randf_range(0,TAU)
		var speed = 10
		props[bullet]["velocity"] = Vector2(speed,0).rotated(v)
		props[bullet]["cooldown"] = 0

		

	"Controls bullets"
	for bullet in bullets:
		bullet.position += props[bullet]["velocity"] * delta
		props[bullet]["velocity"] *= (2**delta)
			
		match props[bullet]["state"]:
			"off":
				bullet.collision_layer = 0
				bullet.modulate.a = 0.3
				props[bullet]["time"] += delta
				
				"Enters on state"
				if props[bullet]["time"] >= props[bullet]["cooldown"]:
					props[bullet]["state"] = "on"
			"on":
				bullet.collision_layer = 2
				bullet.modulate.a = 1
				
func _generate_start_position():
	var v = randf_range(0,2*PI)
	var r = Vector2(300,0)
	var pos = r.rotated(v)
	
	pos += Player.global_position
	return pos
