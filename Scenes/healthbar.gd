extends Node2D

@onready var player = $"../Player"
@onready var sprite2d = $Sprite2D

@onready var start_hp: float = player.start_hp
@onready var start_width: float = position.x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = player.hp/start_hp * start_width
