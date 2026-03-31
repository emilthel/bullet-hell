extends Area2D


var cooldown: float = 0.1
var cooldown_left: float = cooldown
var bullet_scene = "res://level_1c/Scenes/enemy.tscn"
var bullets: Array = []
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cooldown_left-=delta
	
	"Spawns bullet on cooldown"
	if cooldown_left < 0:
		cooldown_left = cooldown
		
		var bullet = load(bullet_scene ).instantiate()
		add_child(bullet)
		bullets.append(bullet)
		
		bullet.position = _generate_spawn_pos()
		bullet.velocity = 0
		
	for bullet in bullets:
		bullet.position +=
	

func _generate_spawn_pos():
	var v = randf_range(0, 2*PI)
	var r = 200
	var pos = Vector2(0,r).rotated(v)
	
	"Centers around player"
	pos += Player.global_position 
	return pos
	
	
