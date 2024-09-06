extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_sprite: AnimatedSprite2D = $Attack

func attack() -> void:
	attack_sprite.visible = false
	animation_player.play("attack")
