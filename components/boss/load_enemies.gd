extends Area2D





func load_enemies() -> void:
	var PHASE_1_ENEMIES = load("res://components/boss/phase_1_enemies.tscn")
	get_parent().call_deferred("add_child", PHASE_1_ENEMIES.instantiate())
	queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		load_enemies()
