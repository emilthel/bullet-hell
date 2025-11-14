extends Area2D
var invincible = false

@export var blood: float = 1
@export var enemy_layer = 2
@export var goal_layer = 4

@onready var level = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

	
func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == enemy_layer:
		blood -= area.damage 
		if blood <= 0:
			get_tree().quit()		
			
	if area.collision_layer == goal_layer:
		level.next_screen()
		
		
