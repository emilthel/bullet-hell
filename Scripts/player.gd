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

@onready var game_over_flash = $GUI/GameOverFlash
@onready var death_flash = $GUI/DeathFlash
@onready var next_screen_flash = $GUI/NextScreenFlash
@onready var next_screen_name = $GUI/NextScreenFlash/ScreenName

@onready var progress_checklist = $GUI/ProgressChecklist
@onready var progress_slot_scene = "res://Scenes/progress_slot.tscn"
@onready var score = "res://Score.txt"
@onready var lives = start_lives
var invincible = false
var progress_slots: Dictionary = {}
enum{GAME_OVER_RECOVERY}
enum{RED,GREEN}
var flash_color = RED
var level
var screen_goal_manager

func _ready() -> void:	
	"Hides mouse"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	
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
			bg.modulate = Color(1,0,0)
		GREEN:
			bg.modulate = Color(0,1,0)
			if invincibility == 0:
				flash_color = RED
				
	bg.modulate.a = invincibility #Sets transparency
	
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
	meaning_corrupted_music.pitch_scale = TimeManager.time_speed ** 0.1  #Slows down when slowmo active




#PROGRESS CHECKLIST
"Changes length of checklist"
func update_length(length):
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
func update_score(count):
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
	if area.collision_layer == enemy_layer: #Hit
		if invincibility == 0: 
			health -= 0.6
			invincibility = 0.6
			hit_sound.play()
			if health <= 0: #Death
				_die()
		
	if area.collision_layer == goal_layer:			 #Goal collection
		if invincibility == 0 or area.ignores_invincibility:
			goal_sound.play()
			area.queue_free()
			if area.custom_heal:
				health += area.heal
			else:
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
		update_score(0)
		
		level.transition.color_rect.color = Color(1,0,0,0.3)

func _game_over():
	level.restart()

	game_over_sound.play() #Plays sound
	game_over_flash.visible = true 
	
	meaning_corrupted_music.stop() #Stops music
	
	"Restarts /resets player values"
	lives = start_lives
	health = max_health
	update_length(0)
	slow_mo.reset_slowmo()
	
	update_length(0)		
	"Changes invincibility color to red"
	bg.modulate = Color(1,0,0,0)

func on_screen_entered():	
	"Resets values"
	health = max_health
	slow_mo.reset_slowmo()
	
	if level.screen_to_load.name == "Start Menu": #If entering start menu
		meaning_corrupted_music.stop() #Stops music
		lives_counter.visible = false #Hides lives counter
		
func on_screen_exited():
	"Resets values"
	health = max_health
	slow_mo.reset_slowmo()
	update_score(0) #Empties checklist

	next_screen_flash.visible = true #Flashes name of next screen
	update_length(level.screen_to_load.goals_needed) #Checklist shows goals needed for next screen
	if game_over_flash.visible: #Stops game over flash
		game_over_flash.visible = false
		
	if level.unloaded_screen.name == "Start Menu":  #If exiting start menu
		meaning_corrupted_music.play() #Starts music
		lives_counter.visible = true #Shows lives counter

func on_goal_collected():
	update_score(screen_goal_manager.goals_collected)
