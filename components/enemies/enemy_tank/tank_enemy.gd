extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var vfx: AnimatedSprite2D = $VFX
@onready var ghost_sprite: Sprite2D = $GhostSprite

@onready var hurtbox_component: Area2D = $HurtboxComponent
@onready var hitbox_component: Area2D = $HitboxComponent




func set_ghost_progress(val: float):
	ghost_sprite.material.set("shader_parameter/ghost_progress", val)

func blocked() -> void:
	vfx.visible = true
	if vfx.is_playing():
		vfx.stop()
	vfx.play("shield_block")
	enemy_sprite.play("hit")
	await vfx.animation_finished
	enemy_sprite.play("blink_idle")

func death() -> void:
	hurtbox_component.queue_free()
	hitbox_component.queue_free()
	Global.enemy_defeated.emit()
	set_process(false)
	enemy_sprite.play("death")
	ghost_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_ghost_progress, 0.0, 1.0, 1.0)
	tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y + 10, 1)
	await tween.finished
	queue_free()
