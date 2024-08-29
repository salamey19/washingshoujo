extends State
class_name PlayerAbility2




func Enter():
	blast()

func Exit():
	player.should_fall = true
	player.using_ability = false
	if !player.is_on_floor():
		player.velocity.y = -205

func blast() -> void:

	player.ability_2_damage = player.current_charges



	player.animated_sprite.play("ability_2_" + str(player.current_charges))
	player.vfx.play("ability_2_" + str(player.current_charges))
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
