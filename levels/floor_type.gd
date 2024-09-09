extends Area2D


@export var floor_type : String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.player_floor_sound.emit(floor_type)
