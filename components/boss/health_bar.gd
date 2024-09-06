extends ProgressBar


@onready var timer: Timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar


var health : int = 10



func set_health(amount) -> void:
	var prev_health = health
	health = amount
	value = health

	if health <= 0:
		queue_free()
	if health < prev_health:
		timer.start()
	else:
		damage_bar.health = health



func _on_timer_timeout() -> void:
	damage_bar.value = health
