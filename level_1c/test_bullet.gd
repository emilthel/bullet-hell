extends Area2D

@export var velocity: Vector2 = Vector2(1000,0)
@export var despawns: bool = true
@export var damage = 0.3

var is_frame1: bool = true
var abilities
var time_speed

func _frame1():
	velocity *= -1
	abilities = $"../Abilities"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false
		
	time_speed = abilities.time_speed
	position += velocity * time_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if despawns:
		queue_free()
