extends Area2D

@export var health_component : HealthComponent

@export var is_boss : bool = false

func damage(amount : int) -> void:
	print("hit")
	if is_boss:
		print("boss hit")
		Global.boss_hurt.emit()
	if health_component != null:
		health_component.damage(amount)
