extends State
class_name PlayerFalling


func Enter():
	player.animated_sprite.play("jump_down")


#can be interrupted by abilites?

func Physics_Update(delta: float):
	if player.is_on_floor():
		if player.velocity.x:
			Transitioned.emit(self, "run")
		else:
			Transitioned.emit(self, "idle")

func Handle_Input(event: InputEvent):
	if event.is_action_pressed("jump") and player.has_jump:
		Transitioned.emit(self, "jump")
	if event.is_action_pressed("dash"):
		Transitioned.emit(self, "dash")
