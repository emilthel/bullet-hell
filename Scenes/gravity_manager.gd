extends Node2D

var test: Array = [1,2,3]
var bodies
var pairs
@export var STRENGTH = 1000
@onready var planet_scene = load("res://Scenes/planet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for n in range(10):
		var planet = planet_scene.instantiate()
		planet.position.x = randf_range(0, 1000)
		planet.position.y = randf_range(0, 1000)
		planet.velocity = Vector2(0,1).rotated(randf_range(0,PI))
		planet.despawns = true
		add_child(planet)
	
	bodies = get_children()
	pairs = _unique_pairs(bodies)
	
func _process(delta: float) -> void:
	for pair in pairs:
		var body1 = pair[0]
		var body2 = pair[1]

		var dir = body1.global_position.direction_to(body2.position)
		var r = body1.global_position.distance_to(body2.position)
		
		var acc = dir * 1/r**2 * STRENGTH
		body1.velocity += acc 

		
########################HELP
func _unique_pairs(array):
	var pairs = []
	for i in range(len(array)):
		var element1 = array[i]
		
		var temp = array.duplicate()
		temp.remove_at(i)
		for element2 in temp:
			var pair = [element1, element2]
			pairs.append(pair)
		
	return pairs
