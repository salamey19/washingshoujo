extends State
class_name PlayerAttack


#deal damage
func Enter():
	player.animated_sprite.play("basic_attack")
	await player.animated_sprite.animation_finished
	Transitioned.emit(self, "idle")
