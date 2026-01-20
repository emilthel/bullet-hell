extends Node2D

@onready var score_counter = $ScoreCounter
@onready var level = $"../Level"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.start_menu = self
	
	var score_file = FileAccess.open("res://Score.txt", FileAccess.READ)
	var score = score_file.get_as_text()
	score_file.close()
	
	score_counter.text = score

func update_score(score_num): 
	var score_file = FileAccess.open("res://Score.txt", FileAccess.READ_WRITE)
	
	"Updates if score is higher"
	var previous_score_num = int(score_file.get_as_text())
	if score_num > previous_score_num: 
		var score = str(score_num)
		score_file.store_string(score)
		score_file.close()
		
func start():
	print("start")
	"Unloads self"
	process_mode = PROCESS_MODE_DISABLED
	visible = false
	
	"Loads game engine"
	level.process_mode = Node.PROCESS_MODE_INHERIT
	level.visible = true
	
	Player.screen_counter.visible = true
	
func _process(delta: float) -> void:
	if Input.is_anything_pressed(): #Press any key to start
		start()
