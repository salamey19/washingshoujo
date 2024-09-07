extends Area2D



#

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):

		get_tree().call_group("Level1", "queue_free")
		#var BOSS_BACKGROUND = load("res://components/boss/boss_background.tscn")
		#get_parent().call_deferred("add_child", BOSS_BACKGROUND.instantiate())
		var boss_fight = load("res://levels/boss_fight.tscn")
		get_parent().call_deferred("add_child", boss_fight.instantiate())
		queue_free()
