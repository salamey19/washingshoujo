extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int = 1
var health : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH


func damage(amount : int) -> void:
	print("ouch")
	health -= amount

	if health <= 0:
		die()

func die() -> void:
	get_parent().queue_free()
