extends State
class_name PlayerAttack

var is_attacking : bool = false
@onready var attack_sfx: AudioStreamPlayer2D = $"../../SFX/AttackSFX"
@onready var happy_voice: AudioStreamPlayer2D = $"../../Voice/Happy"

var delta_temp : float



func move_forward(amount : float) -> void:
	player.position.x += amount * 1.4 * delta_temp

func Physics_Update(delta: float):
	delta_temp = delta
	if player.is_hurt:
		Transitioned.emit(self, "hurt")


#deal damage
func Enter():
	player.has_basic_attack = false
	player.should_fall = false
	player.using_ability = true
	is_attacking = true
	player.velocity.y = 0
	happy_voice.play()
	player.animated_sprite.play("basic_attack")
	player.abilities_animation_player.play("basic_attack")
	attack_sfx.play()
	var tween = create_tween()
	if player.is_left:
		tween.tween_method(move_forward, -3, 1, 0.2)
	else:
		tween.tween_method(move_forward, 3, -1, 0.2)
	await get_tree().create_timer(0.2).timeout
	player.vfx.play("bonk")
	is_attacking = false

	await player.animated_sprite.animation_finished
	if !player.is_on_floor():
		Transitioned.emit(self, "falling")
	else:
		Transitioned.emit(self, "idle")


func Handle_Input(event: InputEvent):
	if event.is_action_pressed("attack") and !is_attacking:
		Transitioned.emit(self, "attack2")

func Exit():
	player.should_fall = true
	player.using_ability = false
