extends Area2D

@export var velocity = Vector2(0,0)
var player
var player_log = []
var acceleration: Vector2 = Vector2(0,0)
var player_acceleration: Vector2
var t: float = 0
enum{SLEEP, INERT, ACTIVATING, ACTIVE}
var state = SLEEP
var bullets = []
var player_velocity
var grid_scale = 1

@onready var sleeper = preload("res://Scenes/sleeper.tscn")
@onready var activation_timer = $ActivationTimer

func _ready() -> void:
	player = get_parent().get_child(0)
	position = player.position

func spawn_grid(distance=100, count=5):
	for x in range(-(count-1),count):
		for y in range(-(count-1),count):
			if not x == 0 or not y == 0:
				var child = sleeper.instantiate()
				add_child(child)
				child.position = Vector2(x*distance, y*distance)
				child.scale *= 0.3
				child.modulate = Color(10,0,0,10)
				bullets.append(child)
			
	
func _process(delta: float) -> void:
	print(state)
	match state:
		SLEEP:
			player_log.append(player.position)
			visible = false
			
			#State transition
			if len(player_log) == 4:
				state = INERT
				position = player.position
				visible = true
				spawn_grid(200)
				
		INERT:
			#Movement
			player_log.append(player.position)
			
			player_velocity = player_log[-1]-player_log[-2]	
			velocity = player_velocity
			position += velocity

			t += delta
			if t > 1:
				state = ACTIVATING
				for bullet in bullets:
					bullet.activate()
				t = 0
				#var tween = get_tree().create_tween()
				#var target_direction = velocity.normalized()
				#tween.tween_property(self, "velocity", target_direction*10, 1)
				
									
		ACTIVATING:
			velocity -= velocity * 10 * delta
			position += velocity
			t += delta
			var t_max = 0.3
			for bullet in bullets:
				bullet.modulate.r = t/t_max
				
			if t > t_max:
				state = ACTIVE
				#velocity = player_velocity.normalized()*10
				velocity = Vector2(0,0)
				
		ACTIVE:
			"Movement"			
			position += velocity			
			scale -= Vector2(1,1)*delta
		
			#
