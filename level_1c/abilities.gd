extends Area2D

var time_speed: float = 1
enum{COOLDOWN, SLOWMO}
var state = COOLDOWN
var slowmo_time: float = 1
var slowmo_cooldown: float = 2 

var is_frame1: bool = true
var slowmo_time_left: float
var slowmo_cooldown_left: float
var ability_bar
var level
var slowmo_bg


func _frame1():
	slowmo_time_left = slowmo_time
	slowmo_cooldown_left = 0
	slowmo_bg = $SlowmoBG
	ability_bar = $AbilityBar
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frame1:
		_frame1()
		is_frame1 = false
	TimeManager.time_speed = time_speed
	
	match state:
		COOLDOWN:
			time_speed = 1
			slowmo_cooldown_left -= delta
			slowmo_bg.modulate.a *= 0.00000001**delta
			ability_bar.scale.x = 1 - slowmo_cooldown_left/slowmo_cooldown
			if slowmo_cooldown_left < 0:
				if Input.is_action_just_pressed("slowmo"):
					_enter_slowmo_state()
			
		SLOWMO:
			time_speed = 0.2
			slowmo_time_left -= delta
			slowmo_bg.modulate.a = (1- slowmo_time_left)*0.5
			if Input.is_action_just_released("slowmo"):
				_enter_cooldown_state()
			if slowmo_time_left < 0:
				_enter_cooldown_state()


func _enter_slowmo_state():
	slowmo_time_left = slowmo_time
	state = SLOWMO
		
func _enter_cooldown_state():
	state = COOLDOWN
	slowmo_cooldown_left = slowmo_cooldown
	
