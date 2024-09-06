extends Area2D

var BOSS_BACKGROUND = load("res://components/boss/boss_background.tscn")




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		ResourceLoader
		get_tree().call_group("Level1", "queue_free")
		get_parent().add_child(BOSS_BACKGROUND.instantiate())
		#queue_free()
