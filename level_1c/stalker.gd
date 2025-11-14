extends Area2D

var log: Array = [Vector2(0,0)]
var velocity: Vector2 = Vector2(0,0)
var enemy_scene: PackedScene = load("res://level_1b/scenes/exponential.tscn")

@export var base: float = 10
@export var spawn_cooldown: float = 0.01
@export var sleep_time: float = 1
@export var damage = 0.4

enum{SLEEP, ACTIVE}
var state =SLEEP

@onready var player = $"../Player"
@onready var level = $".."
@onready var sleep_timer = $SleepTimer
@onready var spawn_timer = $SpawnTimer

func _ready() -> void:
	sleep_timer.wait_time = sleep_time
	spawn_timer.wait_time = spawn_cooldown
	sleep_timer.start()
	
func _enter_active_state():
	collision_mask = 1
	modulate.a = 255
	spawn_timer.start()
	state = ACTIVE
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		SLEEP:
			log.append(player.global_position)

		ACTIVE:			
			velocity = log[1]-log[0]
			
			log.append(player.global_position)
			log.remove_at(0)
			
			position += velocity


func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.position = position
	var direction = Vector2(1,0).rotated(randf_range(0,2*PI))
	enemy.velocity = direction
	enemy.base = 20
	level.add_child(enemy)
	


func _on_sleep_timer_timeout() -> void:
	_enter_active_state()
