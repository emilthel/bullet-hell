extends Node2D

@export var velocity = 5e3
@export var max_cooldown = 0.02

var cooldown = 0
var enemy_scene = "res://Scenes/enemy.tscn"
	
"Process"
func _process(delta: float) -> void:
	"Syncs to global time speed"
	delta *= TimeManager.global_time_speed
	
	"Spawns on cooldown"
	cooldown -= 0.1*delta
	if cooldown < 0: #Spawns and restarts cooldown
		cooldown = max_cooldown
		_spawn()

"Spawns enemy"
func _spawn():
	var enemy = load(enemy_scene).instantiate()
	add_child(enemy)
	
	"Sets values"
	enemy.velocity = Vector2(0,velocity)
	
