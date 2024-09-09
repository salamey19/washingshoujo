extends State
class_name PlayerJump

var is_jumping : bool = false
@onready var jump_voice: AudioStreamPlayer2D = $"../../Voice/Jump"

func Enter():

	player.animated_sprite.play("jump_up")
	is_jumping = true
	jump_voice.play()
	player.velocity.y = player.JUMP_VELOCITY
	player.spawn_afterimage()


func Exit():
	pass


func Physics_Update(delta : float):
	if is_jumping and !player.is_on_floor():
		is_jumping = false
		if player.has_jump:
			player.has_jump = false
		else:
			player.has_double_jump = false

	if player.jump_buffer > 0 and player.has_jump:
		Transitioned.emit(self, "jump")

	if player.is_hurt:
		Transitioned.emit(self, "hurt")
	if not player.is_on_floor():
		player.velocity.y += player.get_grav(player.velocity) * delta
		if Input.is_action_just_released("jump") and player.velocity.y < 0 and player.velocity.y <= (player.JUMP_VELOCITY / 2):
			player.velocity.y = player.JUMP_VELOCITY / 2
		if player.velocity.y > 0.0 :
			Transitioned.emit(self, "falling")


func Handle_Input(event: InputEvent):

	if event.is_action_pressed("jump") and player.has_double_jump and !player.has_jump:
		Transitioned.emit(self, "jump")
	if event.is_action_pressed("dash") and player.has_dash:
		Transitioned.emit(self, "dash")
	if event.is_action_pressed("attack") and player.has_basic_attack:
		Transitioned.emit(self, "attack")
	if player.current_charges > 0:
		if event.is_action_pressed("ability1"):
			Transitioned.emit(self, "ability1")
		if event.is_action_pressed("ability2"):
			Transitioned.emit(self, "ability2")
