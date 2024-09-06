extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.bonk.connect(_bonk)

func _bonk(enemy_position : Vector2) -> void:
	global_position = enemy_position
	global_position.y -= 60
	global_position.x += 40
	play("Bonk")
