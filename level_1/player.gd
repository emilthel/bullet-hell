extends Area2D
var invincible = false

@export var blood: float = 1
@export var enemy_layer = 2
@export var goal_layer = 4

@onready var level = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if blood > 1:
		blood = 1

	
func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == enemy_layer:
		blood -= area.damage 
		if blood <= 0:
			get_tree().quit()		
			
	if area.collision_layer == goal_layer:
		if area.mode == area.SCREEN_CHANGE:
			level.next_screen()
		if area.mode == area.SCRIPT:
			area.on_collected.call()
		area.queue_free()
		blood += area.heal
		
		
