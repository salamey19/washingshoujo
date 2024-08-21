extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		enemy_sprite.play("attack")
		await enemy_sprite.animation_finished
		enemy_sprite.play("blink_idle")



func _on_within_range_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player"):
		pass
