extends Node2D

var sleeper = preload("res://Scenes/sleeper.tscn")
var bullets = []
var t: float = 0
enum{SLEEP, WAKE}
var state = SLEEP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_scale = Vector2(1,1)
	
func activate():
	for bullet in bullets:
		bullet.activate()
		
	
func spawn_grid():
	for x in range(-10,10):
		for y in range(-10,10):
			if not x == 0 or not y == 0:
				var child = sleeper.instantiate()
				add_child(child)
				child.position = Vector2(x*100, y*100)
				child.scale *= 0.3
				bullets.append(child)
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		SLEEP:
			t += delta
			if t > 1:
				state = WAKE
				activate()
		WAKE:
			pass
	
