extends State
class_name PlayerAttack


#deal damage
func Enter():
	player.animated_sprite.play("basic_attack")
	player.abilities_animation_player.play("basic_attack")
	await player.animated_sprite.animation_finished
	if !player.is_on_floor():
		Transitioned.emit(self, "falling")
	else:
		Transitioned.emit(self, "idle")
