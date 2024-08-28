extends State
class_name PlayerRun


func Enter():

	player.animated_sprite.play("run")


func Physics_Update(_delta : float):

	if is_zero_approx(player.velocity.x):
		Transitioned.emit(self, "idle")
	if player.velocity.y > 0.0 :
		Transitioned.emit(self, "falling")

func Handle_Input(event: InputEvent):
	if player.is_hurt:
		Transitioned.emit(self, "hurt")
	if event.is_action_pressed("jump") and player.has_jump:
		Transitioned.emit(self, "jump")
	if event.is_action_pressed("dash"):
		Transitioned.emit(self, "dash")
	if event.is_action_pressed("attack") and player.has_basic_attack:
		Transitioned.emit(self, "attack")
	if player.current_charges > 0:
		if event.is_action_pressed("ability1"):
			Transitioned.emit(self, "ability1")
		if event.is_action_pressed("ability2"):
			Transitioned.emit(self, "ability2")
