extends Area2D


#load in boss fight
#skip cutscene
#deload level 1
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape.disabled = true
	if Global.boss_checkpoint_met:
		collision_shape.disabled = false
		Global.boss_fight_ready.connect(boss)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var BOSS_BACKGROUND = load("res://components/boss/boss_background.tscn")
		get_parent().get_parent().call_deferred("add_child", BOSS_BACKGROUND.instantiate())
		var boss_fight = load("res://levels/boss_fight.tscn")
		get_parent().get_parent().call_deferred("add_child", boss_fight.instantiate())



func boss() -> void:
	get_tree().call_group("Level3", "queue_free")
	get_tree().call_group("Level1", "queue_free")
	if !Global.phase2_reached:
		var PHASE_1_ENEMIES = load("res://components/boss/phase_1_enemies.tscn")
		get_tree().get_first_node_in_group("BossFight").call_deferred("add_child", PHASE_1_ENEMIES.instantiate())
	var boss = get_tree().get_first_node_in_group("Boss")
	boss.enemy_sprite.play("jump_down")
	var tween = create_tween()
	tween.tween_property(boss, "position:y", -77, 1.5)
	await tween.finished
	boss.enemy_sprite.play("idle")

	queue_free()
