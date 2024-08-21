extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var attack_sprite: AnimatedSprite2D = $VFX/AttackSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()



func attack() -> void:
	attack_sprite.visible = true
	enemy_sprite.visible = true
	enemy_sprite.play("blink_attack")
	attack_sprite.play("attack")
	await attack_sprite.animation_finished
	attack_sprite.visible = false
	await enemy_sprite.animation_finished
