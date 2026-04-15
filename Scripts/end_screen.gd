extends Control

@onready var your_time_number = $YourTimeNumber
@onready var best_time_number = $BestTimeNumber
var best_time: int
var records_path = "res://records.dat"

func _ready() -> void:
	Player.on_end_screen_entered()
	"Displays your time"
	your_time_number.text = format_time(Player.playthrough_time)
	
func format_time(ticks_played: int):
	"Converts ticks to min:sec format"
	var seconds = float(ticks_played)/1000
	var minutes = int(seconds/60)
	var seconds_left = int(seconds - minutes*60)
	return "%s min %s sec" % [minutes, seconds_left]
	
# Called every frame. 'delta' isr the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("slowmo"):
		Player.restart_game()
