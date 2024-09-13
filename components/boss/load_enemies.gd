extends Area2D



func _ready() -> void:
	CutsceneManager.start_phase1_boss.connect(load_enemies)

func load_enemies() -> void:
	get_tree().call_group("Level3", "queue_free")
	if !Global.phase2_reached:

		var PHASE_1_ENEMIES = load("res://components/boss/phase_1_enemies.tscn")

		await get_tree().create_timer(0.2).timeout
		get_tree().get_first_node_in_group("BossFight").call_deferred("add_child", PHASE_1_ENEMIES.instantiate())

	queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.phase2_reached:
		queue_free()
	elif body.is_in_group("Player") and !Global.boss_checkpoint_met:
		load_enemies()
	elif Global.boss_checkpoint_met:
		queue_free()
