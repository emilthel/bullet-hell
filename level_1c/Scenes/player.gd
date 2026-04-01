extends Area2D
@export var enemy_layer: int = 2
@export var goal_layer: int = 4
@export var max_blood: float = 2
@export var start_lives: int = 2
@export var slowmo_time: float = 3
@onready var blood = max_blood
@onready var test = max_blood
@onready var invincibility: float = 0
@onready var bg = $GUI/BG
@onready var health_bar =  $GUI/HealthBar
@onready var screen_rect = get_viewport_rect()
@onready var slow_mo = $GUI/SlowMo
@onready var lives_counter = $GUI/LivesCounter
@onready var hit_sound = $Sounds/HitSound
@onready var death_sound = $Sounds/DeathSound
@onready var game_over_sound = $Sounds/GameOverSound
@onready var goal_sound = $Sounds/GoalSound
@onready var game_over_screen = $GUI/GameOverScreen
@onready var death_screen = $GUI/DeathScreen
@onready var progress_checklist = $GUI/ProgressChecklist
@onready var progress_slot_scene = "res://level_1c/Scenes/progress_slot.tscn"
@onready var meaning_corrupted_music = $Sounds/MeaningCorruptedMusic
@onready var visibility_notifier = $VisibilityNotifier
@onready var next_up_screen = $GUI/NextUpScreen
@onready var next_up_screen_name = $GUI/NextUpScreen/ScreenName
@onready var score = "res://Score.txt"
@onready var lives = start_lives
var invincible = false
var progress_slots_filled = 0
var progress_slots: Dictionary = {}
enum{GAME_OVER_RECOVERY}
enum{RED,GREEN}
var flash_color = RED
var level
var state
var start_menu

func _ready() -> void:	
	"Hides mouse"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	
	_progress_checklist_length(0)
	slow_mo.slowmo_time = slowmo_time
"Main script"
func _process(delta: float) -> void:
	"Movement"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	var mouse_pos = get_global_mouse_position()	
	global_position = mouse_pos
	
	if mouse_pos.x < 0: #Snaps to left edge
		global_position.x = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	if mouse_pos.x > 1000: #Snaps to right edge
		global_position.x = 1000
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	if mouse_pos.y < 0: #Snaps to top edge
		global_position.y = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	if mouse_pos.y > 1000: #Snaps to bottom edge
		global_position.y = 1000
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	
	"Health"
	health_bar.scale.x = blood/max_blood #Sets healthbar
	if blood > max_blood: #Caps health (blood) at max
		blood = max_blood
		
		
	"Invinciblity"
	if invincibility > 0: #Decreases invincibility until 0
		invincibility -= delta
	else:
		invincibility = 0  
		
	"Background"
	match flash_color:
		RED:
			bg.modulate = Color(1,0,0)
		GREEN:
			bg.modulate = Color(0,1,0)
			if invincibility == 0:
				flash_color = RED
	bg.modulate.a = invincibility #Sets transparency
	
	"Lives counter"
	print(level.current_screen_name)
	if level.current_screen_name == "Start menu": #Checks current screen
		lives_counter.visible = false #Hides on start menu
	else:
		lives_counter.visible = true
		lives_counter.text = str(lives) #Tracks player lives
	
	"Game over screen"
	#Fades out
	if game_over_screen.visible: #Fades out game over screen
		if game_over_screen.modulate.a > 0:
			game_over_screen.modulate.a -= 0.3 * delta
		else:
			game_over_screen.visible = false #Hides game over screen
			game_over_screen.modulate.a = 1 #Resets transparency for next game over
	
	"Death screen"
	#Fades out
	if death_screen.visible: #Fades out death screen
		if death_screen.modulate.a > 0:
			death_screen.modulate.a -= 1 * delta
		else:
			death_screen.visible = false #Hides death screen
			death_screen.modulate.a = 1 #Resets transparency for next death
	
	"Next up screen"
	#Fades out
	if next_up_screen.visible:
		if next_up_screen.modulate.a > 0: #Fades out next up screen
			next_up_screen.modulate.a -= 1 * delta #Fades out
		else:
			next_up_screen.visible = false #Hides next up screen
			next_up_screen.modulate.a = 1 #Resets transparency for next screen transition
		next_up_screen_name.text = str(level.current_screen_name)
	"Music speed"
	meaning_corrupted_music.pitch_scale = TimeManager.time_speed ** 0.1  #Slows down when slowmo active

#PROGRESS CHECKLIST
"Changes length of checklist"
func _progress_checklist_length(length):
	"Clears progress checklist"
	for n in range(len(progress_slots)):
		progress_slots[n].queue_free()
		progress_slots.erase(n)
	
	"Generates progress checklist"
	for n in range(length):
		var slot = load(progress_slot_scene).instantiate()
		slot.position.x = 100*n
		progress_checklist.add_child(slot)
		progress_slots[n] = slot
"Changes displayed score"
func _progress_checklist_score(count):
	for n in range(len(progress_slots)):
		"Fills in points up to count"
		if n < count:
			var slot = progress_slots[n]
			var point = slot.get_node("ProgressPoint")
			point.visible = true
		
		"Empties remaining points"
		if n >= count:
			var slot = progress_slots[n]
			var point = slot.get_node("ProgressPoint")
			point.visible = false

#COLLIISION
func _on_area_entered(area: Area2D) -> void: #Collision signal
	if area.collision_layer == enemy_layer and invincibility == 0: #Hit
		blood -= 0.3 
		invincibility = 0.3
		hit_sound.play()
		if blood <= 0: #Death
			_die()
		
	if area.collision_layer == goal_layer:			 #Goal collection
		if invincibility == 0 or area.ignores_invincibility:
			goal_sound.play()
			area.queue_free()
			if area.custom_heal:
				blood += area.heal
			else:
				blood += 0.05
			invincibility = 0.1
			flash_color = GREEN
			if area.mode == area.SCREEN_CHANGE: 
				level.advance()
			if area.mode == area.SCRIPT:
				area.on_collected.call()
func _hit(damage):	
	if invincibility == 0:
		blood -= damage 
		invincibility = 0.4
		hit_sound.play()
	if blood <= 0: #Death
		_die()

#TRANSITIONS
func _die():
	lives -= 1
	if lives == 0: #Game over
		_game_over()
	else:
		level.die()				
		blood = max_blood
		
		death_sound.play()
		death_screen.visible = true 
		
		_progress_checklist_score(0)
		
		level.transition.color_rect.color = Color(1,0,0,0.3)
func _game_over():
	level.restart()

	invincibility = 5 #Red flash
	game_over_sound.play() #Plays sound
	game_over_screen.visible = true 
	
	meaning_corrupted_music.stop() #Stops music
	
	"Restarts /resets player values"
	lives = start_lives
	blood = max_blood
	_progress_checklist_length(0)
	slow_mo.reset_slowmo()
	
	_progress_checklist_length(level.screen.goals_needed)		
	"Changes invincibility color to red"
	bg.modulate = Color(1,0,0,0)
	
	_progress_checklist_length(level.screen.goals_needed)
func on_screen_entered():
	next_up_screen.visible = true #Flashes "Next up" screen
	
