extends State
class_name PlayerAttack2

@onready var collision_shape: CollisionShape2D = $"../../Weapon/BasicAttackArea/CollisionShape2D"
@onready var attack_sfx: AudioStreamPlayer2D = $"../../SFX/AttackSFX"

var delta_temp : float

func move_forward(amount : float) -> void:
	player.position.x += amount * 1.4 * delta_temp

func Physics_Update(delta: float):
	delta_temp = delta
#deal damage
func Enter():
	collision_shape.disabled = true
	player.should_fall = false
	player.using_ability = true
	player.velocity.y = 0
	player.animated_sprite.play("basic_attack2")
	player.abilities_animation_player.play("basic_attack2")
	attack_sfx.play()
	var tween = create_tween()
	if player.is_left:
		tween.tween_method(move_forward, -3, 1, 0.2)
	else:
		tween.tween_method(move_forward, 3, -1, 0.2)
	await player.animated_sprite.animation_finished

	if !player.is_on_floor():
		Transitioned.emit(self, "falling")
	else:
		Transitioned.emit(self, "idle")



func Exit():
	player.should_fall = true
	player.using_ability = false
