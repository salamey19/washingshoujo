extends Node2D

@export var enemy : Node2D
const EYE_ENEMY = preload("res://components/enemies/eye_enemy/eye_enemy.tscn")
@export var respawn_timer : float = 0
var timer : float = 0



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_child_count() == 0:
		timer += delta
		if timer > respawn_timer:
			respawn()
			timer = 0

func respawn() -> void:
	var add_enemy = EYE_ENEMY.instantiate()
	add_enemy.rotation = deg_to_rad(0)
	add_enemy.asleep = true
	add_child(add_enemy)
