extends State
class_name PlayerIdle

var first_start : bool = true

func Enter():
	if first_start:
		await player.ready
		first_start = false
	player.animated_sprite.play("idle")


func Physics_Update(_delta: float):
	if player.is_hurt:
		Transitioned.emit(self, "hurt")


	if player.velocity.x > 0 or player.velocity.x < 0:
		Transitioned.emit(self, "run")
	if player.jump_buffer > 0 and player.has_jump:
		Transitioned.emit(self, "jump")


func Handle_Input(event: InputEvent):

	if event.is_action_pressed("dash"):
		Transitioned.emit(self, "dash")
	if event.is_action_pressed("attack") and player.has_basic_attack:
		Transitioned.emit(self, "attack")
	if player.current_charges > 0:
		if event.is_action_pressed("ability1"):
			Transitioned.emit(self, "ability1")
		if event.is_action_pressed("ability2"):
			Transitioned.emit(self, "ability2")
