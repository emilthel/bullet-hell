extends Area2D

var node
var previous_node
@export var period0: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var orbitor = preload("res://orbitor.tscn")
	previous_node = self
	for n in range(0,10):
		node = orbitor.instantiate()
		node.detect_position = false
		node.angle = PI/4
		node.radius = 150*1.1**n
		node.scale = Vector2(1,1)*1.05**-n
		node.period = period0*0.8**-n
		previous_node.add_child(node)
		previous_node = node

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 0 * delta
	
