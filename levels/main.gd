extends Node2D

@export var music : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().root.ready
	var player = get_tree().get_first_node_in_group("Player")
	player.set_process_input(false)
	player.set_physics_process(false)
	player.in_cutscene = true
	if !Global.intro_done:
		CutsceneManager.play_cinematic()
	else:
		music.play()
		player.set_process_input(true)
		player.set_physics_process(true)
		player.in_cutscene = false
	CutsceneManager.play_outro.connect(_outro)

func _outro() -> void:
	if %Transition:
		%Transition.play("fade_in")
