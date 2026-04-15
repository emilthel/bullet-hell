extends Node2D



@export var goals_needed: int = 2
@export var spawns_goals: bool = true
@export var goal_path: String
@export var screen_name: String = "Grid"
@export var bullet_size: float = 0.9
@export var spawn_cooldown: float = 1
var goal_scene: PackedScene = load("res://Scenes/goal.tscn")
var is_frame1: bool = true
var goals_collected: int = 0
var spawn_cooldown_left: float = spawn_cooldown
var spawn_cooldown_active: bool = true
var viewport

@onready var level = $".."

"Initialization"
func _frame1() -> void:
	Player.screen_goal_manager = self
	
	"Gets viewport for random point generation"
	viewport = get_viewport_rect()
	
	"If goal already exists (not spawned)"
	if goal_path:
		var goal = get_node(goal_path)
		goal.mode = goal.SCRIPT
		"Sets goal"
		goal.on_collected = Callable(goal_collected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	"Syncs to global time speed"
	delta *= TimeManager.global_time_speed
	
	"Checks if initialized"
	if is_frame1:
		_frame1()
		is_frame1 = false
	else: 
		"Normal behavior: Spawns goals"
		if spawns_goals:
			if spawn_cooldown_active:
				"Cooldown"
				if spawn_cooldown_left > 0:
					spawn_cooldown_left -= delta
					
				"Spawns goal and resets cooldown"
				if spawn_cooldown_left <= 0:
					spawn_child(_random_point())
					spawn_cooldown_left = spawn_cooldown
					spawn_cooldown_active = false				

"If spawned goal collected,"
func goal_collected():
	goals_collected += 1
	spawn_cooldown_active = true
	spawn_cooldown_left = spawn_cooldown
	
	"Signals to player"
	Player.on_goal_collected()
	
	"If enough collected, goes to next screen"
	if goals_collected == goals_needed: #Advance to next level
		goals_collected == 0
		level.advance()
		
"Spawns goal"
func spawn_child(point):
	var goal = goal_scene.instantiate()
	goal.position = point
	goal.velocity = Vector2(0,0)
	goal.scale *= bullet_size
	goal.mode = goal.SCRIPT
	goal.on_collected = Callable(goal_collected)
	add_child(goal)
	return goal

"Generates random point"
func _random_point():
	var x = randf_range(0, viewport.size.x)
	var y = randf_range(128, viewport.size.y-128)
	return Vector2(x,y)
	
