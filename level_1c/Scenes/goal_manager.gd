extends Node2D

var goals_needed: int
var spawns_goals: bool = true 
var spawn_cooldown: float = 1
var goal_scene: PackedScene = load("res://Scenes/goal.tscn")
var goals_collected: int = 0
var spawn_cooldown_left: float = spawn_cooldown
var spawn_cooldown_active: bool = true

@onready var level = $".."
@onready var screen = get_viewport_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	"Controls time speed"
	delta *= TimeManager.time_speed

	"Normal behavior: Spawns goals"
	if spawns_goals:
		if spawn_cooldown_active:
			"Cooldown"
			if spawn_cooldown_left > 0:
				spawn_cooldown_left -= delta
				
			"Spawns goal and resets cooldown"
			if spawn_cooldown_left <= 0:
				spawn_goal(_random_point())
				spawn_cooldown_left = spawn_cooldown
				spawn_cooldown_active = false



#MISC
"Spawns goal"
func spawn_goal(point):
	var goal = goal_scene.instantiate()
	goal.position = point
	goal.mode = goal.SCRIPT
	goal.on_collected = Callable(on_goal_collected)
	add_child(goal)
	return goal

func despawn_goals():
	for child in get_children():
		child.queue_free()
		
"Generates random point"
func _random_point():
	var x = randf_range(0, screen.size.x)
	var y = randf_range(128, screen.size.y-128)
	return Vector2(x,y)



#TRANSITIONS
func on_goal_collected():
	goals_collected += 1
	spawn_cooldown_active = true
	spawn_cooldown_left = spawn_cooldown
	
	"If enough collected, goes to next screen"
	if goals_collected == goals_needed: #Advance to next level
		level.advance()

func on_screen_entered():
	spawns_goals = level.screen.spawns_goals
	spawn_cooldown = level.screen.spawns_goals
	spawn_cooldown_left = spawn_cooldown
	
func on_screen_exited():
	spawns_goals = false
	despawn_goals()
	
	"Updates values"
	goals_needed = level.screen_to_load.goals_needed
	goals_collected
	
