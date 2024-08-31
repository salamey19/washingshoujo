extends Node2D

var current_checkpoint : Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_fall_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.play("fade_black")
		await get_tree().create_timer(0.5).timeout
		body.position = current_checkpoint.position
		#spawn last checkpoint
