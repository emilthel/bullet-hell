extends Area2D

@export var velocity: Vector2 = Vector2(100,100)
@export var despawns: bool = true
@export var damage = 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity*delta
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if despawns:
		queue_free()
		print("despawn")
