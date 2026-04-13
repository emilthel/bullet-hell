extends Control

@onready var time_label = $TimeLabel

func _ready() -> void:
	Player.calculate_playthrough_time()
	
	time_label.text = format_time(Player.playthrough_time)
func format_time(ticks_played):
	"Converts ticks to min:sec format"
	var seconds = float(ticks_played)/1000
	var minutes = int(seconds/60)
	var seconds_left = int(seconds - minutes*60)
	return "%s min %s sec" % [minutes, seconds_left]
	
# Called every frame. 'delta' isr the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("slowmo"):
		Player.restart_game()
