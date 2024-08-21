extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var vfx: AnimatedSprite2D = $VFX

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
