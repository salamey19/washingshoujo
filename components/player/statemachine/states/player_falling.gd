extends State
class_name PlayerFalling


func Enter():
	player.animated_sprite.play("jump_down")


#can be interrupted by abilites?

func Physics_Update(_delta: float):

	if player.jump_buffer > 0 and player.has_jump and !player.in_cutscene:
		Transitioned.emit(self, "jump")
	if player.is_hurt and player.can_be_hurt:
		Transitioned.emit(self, "hurt")
	if player.is_on_floor():
		if player.velocity.x > 0 or player.velocity.x < 0:
			Transitioned.emit(self, "run")
		else:
			Transitioned.emit(self, "idle")

func Handle_Input(event: InputEvent):

	if !player.in_cutscene:
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
