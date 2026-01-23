extends Node2D

var cooldown = 0
var max_cooldown = 0.02
var enemy_scene = "res://level_1c/Scenes/enemy.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _spawn():
	var enemy = load(enemy_scene).instantiate()
	add_child(enemy)
	enemy.velocity = Vector2(0,5e3)
	print("spawn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	cooldown -= 0.1*delta
	"Spawns and restarts cooldown"
	if cooldown < 0:
		cooldown = max_cooldown
		_spawn()
