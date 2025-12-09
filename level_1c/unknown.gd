extends Area2D
var invincible = false


@export var blood: float = 1
@export var enemy_layer = 2
@export var goal_layer = 4

@onready var level = $".."
@onready var invincibility_timer = $InvincibilityTimer
@onready var bg = $"../BG"
@onready var health_bar =  $"../HealthBar"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= TimeManager.time_speed
	global_position = get_global_mouse_position()
	if blood > 1:
		blood = 1
	bg.modulate.a = invincibility_timer.time_left
	health_bar.scale.x = blood
	
func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == enemy_layer:
		if not invincible:
			blood -= area.damage 
			if blood <= 0:
				get_tree().quit()
			
			invincibility_timer.start()
			invincible = true
			
			
	if area.collision_layer == goal_layer:
		if area.mode == area.SCREEN_CHANGE:
			level.next_screen()
		if area.mode == area.SCRIPT:
			area.on_collected.call()
		area.queue_free()
		blood += area.heal
		
		


func _on_invincibility_timer_timeout() -> void:
	invincible = false
	print("timeout")
