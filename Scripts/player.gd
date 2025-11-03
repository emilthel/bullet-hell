extends Area2D


@export var start_hp: float = 1.0
@export var invincible: bool = false

@onready var hp: float = start_hp

var inv: float = 0

func _coordinate_onscreen(P: Vector2):
	var screen = get_viewport_rect().size
	if 0 < P.x and P.x < screen.x:
		return true
	if 0 < P.y and P.y < screen.y:
		return true
	else:
		return false
	
	
func _hit(damage = 0.1, hit_inv = 0.5):
	if not invincible:
		if not inv > 0:
			print("hit")
			hp -= damage
			inv += hit_inv
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	if _coordinate_onscreen(mouse_pos):
		position = mouse_pos
	if inv > 0:
		inv -= delta
	if hp < 0:
		get_tree().quit()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		_hit(area.damage, area.hit_inv)
