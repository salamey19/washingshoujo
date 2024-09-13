extends State
class_name PlayerHurt



func Enter():
	print("HURT")
	player.hurt()

func Physics_Update(_delta: float):
	if !player.is_hurt:
		if !player.is_on_floor():
			Transitioned.emit(self, "falling")

		if player.velocity.x > 0 or player.velocity.x < 0:
			Transitioned.emit(self, "run")
		else:
			Transitioned.emit(self, "idle")
