extends State
class_name PlayerAbility1

const ABILITY_1_PROJECTILE = preload("res://components/player/ability_1_projectile.tscn")


#freeze character during abilites

func Enter():
	swing()

func Exit():
	player.should_fall = true
	player.using_ability = false
	if !player.is_on_floor():
		player.velocity.y = -205

func swing() -> void:
	player.current_charges -= 1
	player.charges.remove_child(player.charges.get_child(0))
	var b = ABILITY_1_PROJECTILE.instantiate()
	player.animated_sprite.play("ability_1")
	player.should_fall = false
	player.using_ability = true
	player.lock_player()
	await player.animated_sprite.animation_finished
	player.unlock_player()
	player.get_parent().add_child(b)
	b.transform = %Ability1Marker.global_transform
	if !player.is_on_floor():
		Transitioned.emit(self, "falling")
	else:
		Transitioned.emit(self, "idle")
