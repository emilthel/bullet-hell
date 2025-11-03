extends Sprite2D

@onready var player = $"../Player"

func _process(delta: float) -> void:
	modulate = Color(player.inv, player.inv, player.inv)
