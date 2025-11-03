class_name Planet
extends Area2D

@export var start_position = Vector2(0,0)
@export var use_start_position = true #Start position takes priority
@export var despawns = true
@export var damage = 0.1
@export var hit_inv = 0.1
@export var velocity = Vector2(5,5)

@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready() -> void:
	pass
		
func _physics_process(delta: float) -> void:
	position += velocity
	
#HELP FUNCTIONS
func intangible():
	visible = false
	collision_shape_2d.disabled = true
	
#SIGNALS
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if despawns:
		print("despawn")
		set_process(false)
		visible = false
