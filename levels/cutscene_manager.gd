extends Node2D

const BALLOON = preload("res://cutscenes/balloon.tscn")
var balloon
var character_label : RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().root.ready
	if !Global.intro_done:
		play_intro()

var player : CharacterBody2D

func play_intro() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.in_cutscene = true
	balloon = BALLOON.instantiate()
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://cutscenes/intro.dialogue"), "Tutorial")
	player.set_process_input(false)
	player.set_physics_process(false)
	await DialogueManager.dialogue_ended
	player.set_process_input(false)
	player.set_physics_process(true)

func play_intro2() -> void:
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	balloon.start(load("res://cutscenes/intro.dialogue"), "Tutorial2")


func play_intro3() -> void:
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	balloon.start(load("res://cutscenes/intro.dialogue"), "Tutorial3")


func play_intro4() -> void:
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	balloon.start(load("res://cutscenes/intro.dialogue"), "Tutorial4")
	await DialogueManager.dialogue_ended
	player.set_process_input(false)
	player.set_physics_process(true)
	player.in_cutscene = false


var on_wait_player : bool = false

func _physics_process(delta: float) -> void:
	if on_wait_player and player.is_on_floor():
		on_wait_player = false
		player.set_physics_process(false)
		play_intro2()

func player_falls() -> void:
	player.set_physics_process(true)
	player.set_collision_mask_value(1, false)
	await get_tree().create_timer(0.5).timeout
	on_wait_player = true
	player.set_collision_mask_value(1, true)


func _input(event: InputEvent) -> void:
	if attack_input:
		#var intro_hints = get_tree().get_first_node_in_group("IntroHints")
		#intro_hints.get_child(0).intro_popup()
		if event.is_action_pressed("attack"):
			attack_input = false
			#intro_hints.get_child(0).intro_close()
			player_swing()
	if ability1_input:
		if event.is_action_pressed("ability1"):
			player.add_charge()
			ability1_input = false
			player_ability1()


signal do_action(action)
var attack_input : bool = false
func player_swing() -> void:
	do_action.emit("attack")
	get_tree().create_timer(0.5).timeout
	play_intro3()

var ability1_input : bool = false
func player_ability1() -> void:
	do_action.emit("ability1")
	get_tree().create_timer(0.5).timeout
	play_intro4()

func color_akira() -> void:
	character_label.modulate = Color.PALE_VIOLET_RED

func color_riro() -> void:
	character_label.modulate = Color.SKY_BLUE
