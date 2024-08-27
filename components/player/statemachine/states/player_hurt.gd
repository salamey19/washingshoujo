extends State
class_name PlayerHurt



func Enter():
	player.hurt()

func Physics_Update(_delta: float):
	if !player.is_hurt:
		Transitioned.emit(self, "idle")
