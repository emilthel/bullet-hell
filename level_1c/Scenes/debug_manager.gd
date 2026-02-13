extends Node

var input_prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_warp_start"):
		input_prompt = LineEdit.new()
		add_child(input_prompt)		
		var mouse_pos = get_viewport().get_mouse_position()
		input_prompt.position = mouse_pos
		
	if Input.is_action_just_pressed("debug_warp_finish"):
		var warp_index = int(input_prompt.text)
		input_prompt.queue_free()
		warp(warp_index)
		
func warp(warp_index):
	print("warp test")
