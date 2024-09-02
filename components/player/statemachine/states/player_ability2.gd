extends State
class_name PlayerAbility2


@onready var vfx_ability2: AnimatedSprite2D = %VFXAbility2
@onready var ability_2sfx: AudioStreamPlayer2D = $"../../SFX/Ability2SFX"


func Enter():
	blast()

func Exit():
	player.should_fall = true
	player.using_ability = false
	if !player.is_on_floor():
		player.velocity.y = -205

func blast() -> void:
	#2^ - 1
	player.ability_2_damage = pow(2, player.current_charges) - 1




	play_animations(player.current_charges)
	player.current_charges = 0
	player.lock_player()
	player.should_fall = false
	player.using_ability = true
	for charge in player.charges.get_child_count():
		player.charges.remove_child(player.charges.get_child(0))
	await player.animated_sprite.animation_finished
	player.unlock_player()
	if !player.is_on_floor():
		Transitioned.emit(self, "falling")
	else:
		Transitioned.emit(self, "idle")


var scales : Array[float] = [1.0, 1.2, 1.33]

func play_animations(current_charges : int) -> void:


	if player.is_left:
		vfx_ability2.get_parent().scale.x = -1
		vfx_ability2.position = Vector2(1156, 176)
	else:
		vfx_ability2.get_parent().scale.x = 1
		vfx_ability2.position = Vector2(1380, 176)

	vfx_ability2.scale = Vector2(scales[current_charges - 1], scales[current_charges - 1])
	player.animated_sprite.play("ability_2_" + str(current_charges))
	vfx_ability2.play("ability_2_" + str(current_charges))
	ability_2sfx.play()
	await get_tree().create_timer(0.15).timeout
	player.abilities_animation_player.play("ability_2_" + str(current_charges))
