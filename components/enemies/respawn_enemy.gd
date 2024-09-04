extends Node2D

@export var enemy : Node2D
#const EYE_ENEMY = preload("res://components/enemies/eye_enemy/eye_enemy.tscn")
@export var respawn_timer : float = 0
var timer : float = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy.dead:
		timer += delta
		if timer > respawn_timer:
			respawn()
			timer = 0

func respawn() -> void:
	enemy.enemy_sprite.play("sleep")
	#enemy.position.y += 20
	enemy.hurtbox_component.set_deferred("monitorable", true)
	enemy.hurtbox_component.set_deferred("monitoring", true)
	enemy.hitbox_component.set_deferred("monitoring", true)
	enemy.hitbox_component.set_deferred("monitorable", true)
	enemy.visible = true
	enemy.dead = false
