extends Area2D

var log: Array = []
var velocity: Vector2 = Vector2(0,0)
var t: float = 0

@onready var player = $"../Player"

func _activate():
	collision_mask = 1
	modulate.a = 255
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	if t > 3:
		_activate()
		
	log.append(player.global_position)

	if len(log) == 100:
		log.remove_at(0)
		position = log[0]
		velocity = log[1]-log[0]
	
	position += velocity
