extends Node2D

var screen
var goal_scene: PackedScene = load("res://level_1c/Scenes/goal.tscn")
var is_frame1: bool = true
var goals_collected: int = 0

@export var goals_needed: int = 2
@export var goal_heal = 0.2
@export var spawns_goals: bool = true
@export var goal_path: String

@onready var spawn_timer = $SpawnTimer
@onready var level = $".."
@onready var progress_bar = Player.progress_bar
@onready var progress_bar_cover = Player.progress_bar_cover

# Called when the node enters the scene tree for the first time.
func _frame1() -> void:
	screen = get_viewport_rect()
	if spawns_goals:
		spawn_child(_random_point())
	if goal_path:
		var goal = get_node(goal_path)
		goal.mode = goal.SCRIPT
		goal.heal = goal_heal
		goal.on_collected = Callable(goal_collected)
	
func goal_collected():
	spawn_child(_random_point())
	goals_collected += 1
	if goals_collected == goals_needed:
		goals_collected == 0
		level.next_screen()

func spawn_child(point):
	var goal = goal_scene.instantiate()
	goal.position = point
	goal.velocity = Vector2(0,0)
	goal.scale *= 0.9
	goal.mode = goal.SCRIPT
	goal.heal = goal_heal
	goal.on_collected = Callable(goal_collected)
	add_child(goal)
	return goal
	
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(128, screen.size.y-128)
	return Vector2(x,y)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if is_frame1:
		_frame1()
		is_frame1 = false
	else:
		pass
		#print("progress scale: ", progress_bar.scale.x)
			
func _on_spawn_timer_timeout() -> void:
	spawn_child(_random_point())
