extends State
class_name PlayerAbility2




func Enter():
	blast()

func blast() -> void:

	player.ability_2_damage = player.current_charges
	player.lock_player()

	player.animated_sprite.play("ability_2_" + str(player.current_charges))

	for charge in player.charges.get_child_count():
		player.charges.remove_child(player.charges.get_child(0))
	await player.animated_sprite.animation_finished
	player.unlock_player()
	Transitioned.emit(self, "idle")
