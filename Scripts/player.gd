extends Area2D
@export var enemy_layer: int = 2
@export var goal_layer: int = 4
@export var max_health: float = 1
@export var start_lives: int = 2
@export var slowmo_time: float = 3
@onready var health = max_health
@onready var invincibility: float = 0
@onready var screen_rect = get_viewport_rect()
@onready var bg = $GUI/BG
@onready var health_bar =  $GUI/HealthBar
@onready var slow_mo = $GUI/SlowMo
@onready var lives_counter = $GUI/LivesCounter

@onready var hit_sound = $Sounds/HitSound
@onready var death_sound = $Sounds/DeathSound
@onready var game_over_sound = $Sounds/GameOverSound
@onready var goal_sound = $Sounds/GoalSound
@onready var meaning_corrupted_music = $Sounds/MeaningCorruptedMusic
@onready var game_completed_sound = $Sounds/GameCompletedSound
@onready var game_over_flash = $GUI/GameOverFlash
@onready var death_flash = $GUI/DeathFlash
@onready var next_screen_flash = $GUI/NextScreenFlash
@onready var next_screen_name = $GUI/NextScreenFlash/ScreenName

@onready var progress_checklist = $GUI/ProgressChecklist
@onready var progress_slot_scene = "res://Scenes/progress_slot.tscn"
@onready var score = "res://Score.txt"
@onready var lives = start_lives

@onready var is_first_playthrough: bool = true
var invincible = false
var progress_slots: Dictionary = {}
enum{GAME_OVER_RECOVERY}
enum{RED,GREEN}
var flash_color = RED
var level
var screen_goal_manager
var playthrough_time: int
var completion_time: int
var previous_completion_time: int

func _ready() -> void:	
	"Hides mouse"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	
	"Inputs slowmo time"
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
	health_bar.scale.x = health/max_health #Sets healthbar
	if health > max_health: #Caps health (health) at max
		health = max_health
		
		
	"Invinciblity"
	if invincibility > 0: #Decreases invincibility until 0
		invincibility -= delta
	else:
		invincibility = 0  
		
	"Background"
	match flash_color:
		RED:
			bg.color = Color(1,0,0)
		GREEN:
			bg.color = Color(0,1,0)
			if invincibility == 0:
				flash_color = RED
				
	bg.color.a = invincibility #Sets transparency
	
	"Lives counter"
	lives_counter.text = str(lives) #Tracks player lives
	
	"Game over flash"
	#Fades out
	if game_over_flash.visible: #Fades out game over flash
		if game_over_flash.modulate.a > 0:
			game_over_flash.modulate.a -= 0.2 * delta
		else:
			game_over_flash.visible = false #Hides game over screen
			game_over_flash.modulate.a = 1 #Resets transparency for next game over
	
	"Death flash"
	#Fades out
	if death_flash.visible: #Fades out death screen
		if death_flash.modulate.a > 0:
			death_flash.modulate.a -= 1 * delta
		else:
			death_flash.visible = false #Hides death screen
			death_flash.modulate.a = 1 #Resets transparency for next death
	
	"Next screen flash"
	#Fades out
	if next_screen_flash.visible:
		if next_screen_flash.modulate.a > 0: #Fades out next up screen
			next_screen_flash.modulate.a -= 1 * delta #Fades out
		else:
			next_screen_flash.visible = false #Hides next up screen
			next_screen_flash.modulate.a = 1 #Resets transparency for next screen transition
		next_screen_name.text = level.screen_to_load.name
	"Music speed"
	meaning_corrupted_music.pitch_scale = TimeManager.global_time_speed ** 0.1  #Slows down when slowmo active




#PROGRESS CHECKLIST
"Changes length of checklist"
func update_checklist_length(length):
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
func update_checklist_score(count):
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




#COLLISION
func _on_area_entered(area: Area2D) -> void: #Collision signal
	"Hitting enemies"
	if area.collision_layer == enemy_layer: #Hit
		if invincibility == 0: 
			health -= 0.6
			invincibility = 0.6
			hit_sound.play()
			if health <= 0: #Death
				_die()
		
	"Getting goals"
	if area.collision_layer == goal_layer:			 #Goal collection
		if invincibility == 0 or area.ignores_invincibility:
			goal_sound.play()
			area.queue_free()
			health += 0.05
			invincibility = 0.1
			flash_color = GREEN
			if area.mode == area.SCREEN_CHANGE: 
				level.advance()
			if area.mode == area.SCRIPT:
				area.on_collected.call()




#TRANSITIONS
func _die():
	lives -= 1
		
	if lives == 0: #Game over
		_game_over()
	else:
		level.die()
		
		"Resets values"
		health = max_health
		slow_mo.reset_slowmo()
		
		"Plays sound"
		death_sound.play()
		death_flash.visible = true 
		
		"Empties progress checklist"
		update_checklist_score(0)
		
		"Makes background of transition red instead of blue"
		level.transition.color_rect.color = Color(1,0,0,0.3)

func _game_over():
	"Brings you back to screen 1"
	level.restart()
	
	game_over_sound.play() #Plays sound
	game_over_flash.visible = true 
	
	meaning_corrupted_music.stop() #Stops music
	
	"Restarts /resets player values"
	lives = start_lives
	health = max_health
	update_checklist_length(0)
	slow_mo.reset_slowmo()
	
	update_checklist_length(0)		
	"Changes invincibility color to red"
	bg.color = Color(1,0,0,0)

func restart_game():
	level.restart()	
	
	#Like game over, but does not play game over screen
	
	meaning_corrupted_music.stop() #Stops music
	
	"Restarts /resets player values"
	lives = start_lives
	health = max_health
	update_checklist_length(0)
	slow_mo.reset_slowmo()
	
	update_checklist_length(0)		
	"Changes invincibility color to red"
	bg.color = Color(1,0,0)

func on_screen_entered():	
	"Resets values"
	health = max_health
	slow_mo.reset_slowmo()
	
	update_checklist_length(level.screen_to_load.goals_needed) #Updates checklist

func on_start_menu_entered():
	meaning_corrupted_music.stop() #Stops music
	lives_counter.visible = false #Hides lives counter
	
func on_end_screen_entered():
	game_completed_sound.play()
	meaning_corrupted_music.stop()
	
	"Calculates time of current playthrough in ticks"
	var completion_time = Time.get_ticks_msec()
	if is_first_playthrough:
		playthrough_time = completion_time
	else:
		playthrough_time = completion_time - previous_completion_time
	is_first_playthrough = false

	"Updates previous completion time"
	previous_completion_time = completion_time
	
func on_screen_exited():
	"Resets values"
	health = max_health
	slow_mo.reset_slowmo()

	next_screen_flash.visible = true #Flashes name of next screen
	if game_over_flash.visible: #Stops game over flash
		game_over_flash.visible = false
		
	if level.unloaded_screen.name == "Start Menu":  #If exiting start menu
		meaning_corrupted_music.play() #Starts music
		lives_counter.visible = true #Shows lives counter
		
func on_goal_collected():
	update_checklist_score(screen_goal_manager.goals_collected)




#MISC
		
	
