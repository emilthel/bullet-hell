extends Area2D

var log: Array = [Vector2(0,0)]
var velocity: Vector2 = Vector2(0,0)
var time_slept: float = 0
var spawn_cooldown: float = 0
var last_nonzero_velocity = Vector2(0,0)
var enemy_scene = load("res://level_1/enemy.tscn")

enum{SLEEP, ACTIVE}
var state =SLEEP

@onready var player = $"../Player"
@onready var level = $".."

func _enter_active_state():
	collision_mask = 1
	modulate.a = 255
	state = ACTIVE
	spawn_cooldown = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		SLEEP:
			time_slept += delta
			log.append(player.global_position)
			if time_slept > 1:
				_enter_active_state()

		ACTIVE:			
			velocity = log[1]-log[0]
			
			log.append(player.global_position)
			log.remove_at(0)
			
			if velocity != Vector2(0,0):
				last_nonzero_velocity = velocity
			spawn_cooldown -= delta * 10
			if spawn_cooldown < 0:
				var enemy = enemy_scene.instantiate()
				spawn_cooldown = 1
				enemy.position = position
				enemy.velocity = last_nonzero_velocity.normalized()*1000
				level.add_child(enemy)

			position += velocity
