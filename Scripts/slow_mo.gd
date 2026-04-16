extends Area2D

var time_speed: float = 1
enum{COOLDOWN, READY, SLOWMO}
var state = COOLDOWN
var slowmo_time: float = 1
var slowmo_cooldown: float = 2 

var is_frame1: bool = true
var slowmo_time_left: float
var slowmo_cooldown_left: float = 0
var level
@onready var slowmo_bg = $SlowmoBG
@onready var cooldown_bar = $CooldownBar
@onready var cooldown_text = $CooldownText
func _ready() -> void:
	slowmo_time_left = slowmo_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	"Makes time speed global"
	TimeManager.global_time_speed = time_speed

	match state:
		COOLDOWN: #Charging up slowmo
			"If time runs out, now ready"
			slowmo_cooldown_left -= delta #Cooldown
			if slowmo_cooldown_left < 0:
				_enter_ready_state()
			
			"Shows cooldown with ability bar"
			cooldown_bar.scale.x = 1 - slowmo_cooldown_left/slowmo_cooldown  #
			
			"Shows cooldown warning while space pressed, fades out when released"
			if Input.is_action_pressed("slowmo"):
				cooldown_text.modulate.a = 1
			else:
				cooldown_text.modulate.a *= 0.00001 **delta 
			
			
			"Fades out background"
			slowmo_bg.modulate.a *= 0.00000001**delta

		READY: #Ready to use slowmo
			if Input.is_action_just_pressed("slowmo"):
				_enter_slowmo_state()
				
			"Fades out ability bar (and cooldown warning if visible) "
			cooldown_bar.modulate.a *= 0.0001**delta 
			cooldown_text.modulate.a *= 0.001 **delta

		SLOWMO: #Using slowmo
			"Slows down time"
			time_speed = 0.2
			
			"Fades out cooldown text and bar"
			cooldown_bar.modulate.a *= 0.0001**delta
			cooldown_text.modulate.a *= 0.0001**delta

			"If releasing space or if time runs out, exits slowmo"
			slowmo_time_left -= delta
			if Input.is_action_just_released("slowmo") or slowmo_time_left <0: 
				time_speed = 1 #Resets time speed
				enter_cooldown_state()
			
			"Shows time left with background color"
			slowmo_bg.modulate.a = (slowmo_time - slowmo_time_left)/slowmo_time



#########STATE CHANGE
func _enter_slowmo_state():
	state = SLOWMO
	slowmo_time_left = slowmo_time
	
func _enter_ready_state():
	state = READY

func enter_cooldown_state():
	state = COOLDOWN
	slowmo_cooldown_left = slowmo_cooldown #Restarts cooldown
	
	"Shows ability bar"
	cooldown_bar.modulate.a = 1
	cooldown_bar.scale.x = 0
	
	
func reset_slowmo():
	_enter_ready_state()
	time_speed = 1 #Resets time speed

	"Instantly hides ability bar and cooldown, bypassing fadeout"
	cooldown_bar.modulate.a = 0
	cooldown_text.modulate.a = 0
