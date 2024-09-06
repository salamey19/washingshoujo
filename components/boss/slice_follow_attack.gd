extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func attack1() -> void:
	animation_player.play("attack1")

func attack2() -> void:
	animation_player.play("attack2")

func attack3() -> void:
	animation_player.play("attack3")
