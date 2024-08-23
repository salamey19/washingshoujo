extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var vfx: AnimatedSprite2D = $VFX
@onready var ghost_sprite: Sprite2D = $GhostSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		vfx.visible = true
		vfx.play("shield_block")
		enemy_sprite.play("hit")
		await vfx.animation_finished
		enemy_sprite.play("blink_idle")

func set_ghost_progress(val: float):
	ghost_sprite.material.set("shader_parameter/ghost_progress", val)

func death() -> void:
	set_process(false)
	enemy_sprite.play("death")
	ghost_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_ghost_progress, 0.0, 1.0, 1.0)
	tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y + 10, 1)
	await tween.finished
	queue_free()
