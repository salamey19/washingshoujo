extends State
class_name PlayerJump


func Enter():
	player.animated_sprite.play("jump_up")
	player.velocity.y = player.JUMP_VELOCITY
	player.spawn_afterimage()


func Physics_Update(delta : float):
	if not player.is_on_floor():
		player.velocity.y += player.get_grav(player.velocity) * delta
		if Input.is_action_just_released("jump") and player.velocity.y < 0 and player.velocity.y <= (player.JUMP_VELOCITY / 2):
			player.velocity.y = player.JUMP_VELOCITY / 2
		if player.velocity.y > 0.0 :
			Transitioned.emit(self, "falling")


func Handle_Input(event: InputEvent):
	if event.is_action_pressed("jump") and player.has_jump:
		Transitioned.emit(self, "jump")
	if event.is_action_pressed("dash"):
		Transitioned.emit(self, "dash")
	if event.is_action_pressed("attack"):
		Transitioned.emit(self, "attack")
	if player.current_charges > 0:
		if event.is_action_pressed("ability1"):
			Transitioned.emit(self, "ability1")
		if event.is_action_pressed("ability2"):
			Transitioned.emit(self, "ability2")
