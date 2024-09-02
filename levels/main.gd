extends Node2D

const BALLOON = preload("res://cutscenes/balloon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await ready
	var balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://cutscenes/intro.dialogue"), "Tutorial")
	get_tree().get_first_node_in_group("Player").set_physics_process(false)
	await DialogueManager.dialogue_ended
	get_tree().get_first_node_in_group("Player").set_physics_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
