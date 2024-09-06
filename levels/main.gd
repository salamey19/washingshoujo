extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().root.ready
	var player = get_tree().get_first_node_in_group("Player")
	player.set_process_input(false)
	player.set_physics_process(false)
	player.in_cutscene = true
	if !Global.intro_done:
		CutsceneManager.play_intro()
	else:
		player.set_process_input(true)
		player.set_physics_process(true)
		player.in_cutscene = false
