extends Area2D
var invincible = false

@export var enemy_layer: int = 2
@export var goal_layer: int = 4
@export var max_blood: float = 2
@export var lives: int = 2
@export var slowmo_time: float = 1

@onready var blood = max_blood
@onready var test = max_blood
@onready var invincibility: float = 0
@onready var bg = $GUI/BG
@onready var health_bar =  $GUI/HealthBar
@onready var screen_rect = get_viewport_rect()
@onready var slow_mo = $GUI/SlowMo
@onready var progress_bar = $GUI/ProgressBar
@onready var progress_bar_cover = $GUI/ProgressBarCover
@onready var lives_counter = $GUI/DeathScreen/LivesCounter
@onready var screen_counter = $GUI/ScreenCounter
@onready var hit_sound = $Sounds/HitSound
@onready var death_sound = $Sounds/DeathSound
@onready var game_over_sound = $Sounds/GameOverSound
@onready var goal_sound = $Sounds/GoalSound
@onready var game_over_screen = $GUI/GameOverScreen
@onready var death_screen = $GUI/DeathScreen
@onready var progress_checklist = $GUI/ProgressChecklist
@onready var screen_name = $GUI/NameIndicator/ScreenName
@onready var next_up_text = $GUI/NameIndicator/NextUpText
@onready var progress_slot_scene = "res://level_1c/Scenes/progress_slot.tscn"
@onready var meaning_corrupted_music = $Sounds/MeaningCorruptedMusic
@onready var visibility_notifier = $VisibilityNotifier
#@onready var goals_collected = 0
@onready var score = "res://Score.txt"
var level
var start_menu
var progress_slots_filled = 0
var progress_slots: Dictionary = {}

enum{GAME_OVER_RECOVERY}
var state

enum{RED,GREEN}
var flash_color = RED

func _ready() -> void:
	lives_counter.text = str(lives)
	
	"Hides mouse"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	
	slowmo_activate()
	_progress_checklist_length(0)
	slow_mo.slowmo_time = slowmo_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	"Movement"
	var target_position = get_global_mouse_position()
	visibility_notifier.global_position =  target_position
	
	if visibility_notifier.is_on_screen():
		global_position = target_position
		
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

	"Death screen"
	screen_counter.text = str(level.screen_index)
	#progress_bar.scale.x = 0.1 * goals_collected #Sets progress bar
	
	"Game over screen"
	if game_over_screen.visible: #Fades out game over screen
		if game_over_screen.modulate.a > 0:
			game_over_screen.modulate.a -= 0.3 * delta
		else:
			game_over_screen.visible = false #Hides game over screen
			game_over_screen.modulate.a = 1 #Resets transparency for next game over
			print(game_over_screen.visible)
			
	"Death screen"
	if death_screen.visible: #Fades out death screen
		if death_screen.modulate.a > 0:
			death_screen.modulate.a -= 1 * delta
		else:
			death_screen.visible = false #Hides death screen
			death_screen.modulate.a = 1 #Resets transparency for next death
			print(death_screen.visible)
	lives_counter.text = str(lives)

	#print(slow_mo.process_mode)


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
		
	
#func _on_invincibility_timer_timeout() -> void:
	#invincible = false

func _die():
	print("die")
	lives -= 1
	if lives == 0: #Game over
		game_over()
	else:
		lives_counter.text = str(lives)
		level.die()				
		blood = max_blood
		
		invincibility = 1.5 #Red flash
		death_sound.play()
		death_screen.visible = true 
		
func _hit(damage):	
	if invincibility == 0:
		blood -= damage 
		invincibility = 0.2
		hit_sound.play()
	if blood <= 0: #Death
		_die()
	
func game_over():
	print("game_over")
	start_menu.update_score(level.screen_index)
	level.restart()

	invincibility = 5 #Red flash
	game_over_sound.play() #Plays sound
	game_over_screen.visible = true 
	
	meaning_corrupted_music.stop() #Stops music
	
	"Restarts /resets player values"
	lives = 2
	blood = max_blood
	screen_counter.visible = false
	_progress_checklist_length(0)
	next_up_text.visible = false
	screen_name.visible = false
	slow_mo.reset_slowmo()
	#get_tree().reload_current_scene()
			
func name_indicator_update():
	print("on_transition_entered")
	var new_screen = level.get_next_screen()
	progress_bar_cover.scale.x = 0.3 * (new_screen.goals_needed -1)
	screen_name.text = new_screen.screen_name
	print(new_screen)
	print(new_screen.screen_name)
	slow_mo.reset_slowmo()


	"Initializes screen name,for when entering level 1"
	screen_name.visible = true
	"Shows 'next up' text"
	next_up_text.visible = true
	#goals_collected = 0
	invincibility = 1
	
func on_transition_entered(update_name_indicator = true):
	if update_name_indicator:
		name_indicator_update()

func on_screen_0_entered():
	print("on_screen_0_entered")
	screen_counter.visible = true
	
	_progress_checklist_length(level.screen.goals_needed)

	
func on_screen_entered():
	print("on_screen_entered")
	"Changes invincibility color to red"
	bg.modulate = Color(1,0,0,0)
	
	"Removes 'next up' text"
	next_up_text.visible = false
	_progress_checklist_length(level.screen.goals_needed)
	
	
func on_start_menu_exited():
	game_over_screen.visible = false #Hides game over text
	invincibility = 0 #Stops red flash
	game_over_sound.stop() #Stops game over sound
	meaning_corrupted_music.play() #Starts music

#func on_level_entered():
	#print("on_level_entered")
	#var new_screen = level.get_next_screen()
	#progress_bar_cover.scale.x = 0.3 * (new_screen.goals_needed -1)
	#_progress_checklist_length(new_screen.goals_needed)
	#goals_collected = 0
	#invincibility = 1
	#"Changes invincibility color to green"
	#bg.modulate = Color(0,1,0,0)
	
	
"On hitting enemies or collecting goals"
func _on_area_entered(area: Area2D) -> void: #Collision
	#print("on_area_entered")
	if area.collision_layer == enemy_layer: #Hit
		_hit(area.damage)
		
	if area.collision_layer == goal_layer: #Goal collection
		goal_sound.play()
		area.queue_free()
		blood += area.heal
		invincibility += 0.1
		flash_color = GREEN
		
		if area.mode == area.SCREEN_CHANGE: 
			level.next_screen()
		if area.mode == area.SCRIPT:
			area.on_collected.call()
		_progress_checklist_score(level.screen.goals_collected)
		
	slowmo_activate()

			
func slowmo_activate():
	slow_mo.process_mode = Node.PROCESS_MODE_INHERIT
	slow_mo.visible = true
