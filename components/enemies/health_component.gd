extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int = 1
@export var tank_amount : int = 0
var health : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH


func damage(amount : int) -> void:

	if amount < tank_amount:
		if get_parent().has_method("blocked"):
			get_parent().blocked()
	else:
		print("ouch")
		health -= amount

		if health <= 0:
			die()

func die() -> void:
	if get_parent().has_method("death"):
		get_parent().death()
		queue_free()
	else:
		get_parent().queue_free()
