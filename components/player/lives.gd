extends HBoxContainer



const heart1 = preload("res://art/2d/UI/Hearts/Untitled_Artwork-2.png")
const heart2 = preload("res://art/2d/UI/Hearts/Untitled_Artwork-3.png")
const heart3 = preload("res://art/2d/UI/Hearts/Untitled_Artwork-4.png")


func lose_life() -> void:
	if get_child(2).visible:
		get_child(2).visible = false
	elif get_child(1).visible:
		get_child(1).visible = false
	else:
		get_child(0).visible = false

func add_life() -> void:
	if !get_child(2).visible:
		get_child(2).visible = true
	elif !get_child(1).visible:
		get_child(1).visible = true
