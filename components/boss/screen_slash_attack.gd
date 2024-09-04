extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack() -> void:
	animation_player.play("attack")
