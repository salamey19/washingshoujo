extends Area2D

var background1 = load("res://components/backgrounds/background.tscn")
var background2 = load("res://components/backgrounds/background_2.tscn")

var enemies = load("res://components/enemies/enemies.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !Global.boss_checkpoint_met:
		#get_parent().add_child(background1.instantiate())
		#get_parent().add_child(background2.instantiate())
		#get_parent().add_child(enemies.instantiate())
		get_parent().call_deferred("add_child", background1.instantiate())
		get_parent().call_deferred("add_child", background2.instantiate())
		get_parent().call_deferred("add_child", enemies.instantiate())
		queue_free()
	else:
		queue_free()
