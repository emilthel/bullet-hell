extends Node2D

var screen
var goal_scene: PackedScene = load("res://level_1c/Scenes/goal.tscn")
var is_frame1: bool = true
var goals_collected: int = 0

@export var goals_needed: int = 2
@export var goal_heal = 0.2
@export var spawns_goals: bool = true
@export var goal_path: String
@export var screen_name: String = "Grid"
@export var bullet_size: float = 0.9
@export var spawn_cooldown: float = 1
var spawn_cooldown_left: float = spawn_cooldown
var spawn_cooldown_active: bool = true

@onready var level = $".."
@onready var progress_bar = Player.progress_bar
@onready var progress_bar_cover = Player.progress_bar_cover

# Called when the node enters the scene tree for the first time.
func _frame1() -> void:
	screen = get_viewport_rect()
	if goal_path:
		var goal = get_node(goal_path)
		goal.mode = goal.SCRIPT
		goal.heal = goal_heal
		goal.on_collected = Callable(goal_collected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	delta *= TimeManager.time_speed
	if is_frame1:
		_frame1()
		is_frame1 = false
	else:
		if spawn_cooldown_active:
			if spawn_cooldown_left > 0:
				spawn_cooldown_left -= delta
				
			if spawn_cooldown_left <= 0:
				spawn_child(_random_point())
				spawn_cooldown_left = spawn_cooldown
				spawn_cooldown_active = false
				
		print(spawn_cooldown_left)
				

func goal_collected():
	goals_collected += 1
	spawn_cooldown_active = true
	spawn_cooldown_left = spawn_cooldown
	if goals_collected == goals_needed:
		goals_collected == 0
		level.next_screen()

func spawn_child(point):
	var goal = goal_scene.instantiate()
	goal.position = point
	goal.velocity = Vector2(0,0)
	goal.scale *= bullet_size
	goal.mode = goal.SCRIPT
	goal.heal = goal_heal
	goal.on_collected = Callable(goal_collected)
	add_child(goal)
	return goal
	
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(128, screen.size.y-128)
	return Vector2(x,y)

func restart():
	pass
	
