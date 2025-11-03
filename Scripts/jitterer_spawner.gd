extends Node2D

var jitterer_scene = load("res://Scenes/jitterer.tscn")
var child

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(10):
		for x in range(10):
			child = jitterer_scene.instantiate()
			child.position = Vector2(x,y)*100
			add_child(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
