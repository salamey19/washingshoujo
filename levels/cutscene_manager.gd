extends Node2D

const BALLOON = preload("res://cutscenes/balloon.tscn")
var balloon
var character_label : RichTextLabel

signal start_phase1_cutscene
signal play_audio
signal show_sprites
signal start_phase1_boss
signal start_phase2
signal boss_jump

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().root.ready

	start_phase1_cutscene.connect(_start_phase1)

var player : CharacterBody2D

func play_cinematic() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.in_cutscene = true
	balloon = BALLOON.instantiate()
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://cutscenes/intro.dialogue"), "Cinematic")
	player.set_process_input(false)
	player.set_physics_process(false)
	await DialogueManager.dialogue_ended
	play_intro()

func play_intro() -> void:
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
var on_wait_player_phase1: bool = false
var on_wait_player_phase1_2: bool = false
func _physics_process(_delta: float) -> void:
	if on_wait_player and player.is_on_floor():
		on_wait_player = false
		player.set_physics_process(false)
		play_intro2()
	if on_wait_player_phase1 and player.is_on_floor():
		on_wait_player_phase1 = false
		player.set_physics_process(false)
		play_phase1_2()
	if on_wait_player_phase1_2 and player.is_on_floor():
		on_wait_player_phase1_2 = false
		player.in_cutscene = false
		player.set_process_input(true)
		player.set_physics_process(true)
		start_phase1_boss.emit()


func player_falls() -> void:
	player.set_physics_process(true)
	player.set_collision_mask_value(1, false)
	await get_tree().create_timer(0.5).timeout
	on_wait_player = true
	player.set_collision_mask_value(1, true)

func player_falls2() -> void:
	player.set_physics_process(true)
	player.set_collision_mask_value(1, false)
	await get_tree().create_timer(1.3).timeout
	on_wait_player_phase1_2 = true
	player.set_collision_mask_value(1, true)


func player_falls_phase1() -> void:
	var boss = get_tree().get_first_node_in_group("Boss")
	boss.enemy_sprite.play("jump_down")
	var tween = create_tween()
	tween.tween_property(boss, "position:y", -77, 1.5)
	await get_tree().create_timer(1.0).timeout
	boss.enemy_sprite.play("idle")
	player.set_physics_process(true)
	player.set_collision_mask_value(1, false)
	await get_tree().create_timer(1.5).timeout
	on_wait_player_phase1 = true
	player.set_collision_mask_value(1, true)

var attack_hint_shown : bool = false
var ability1_hint_shown : bool = false

func _input(event: InputEvent) -> void:
	if attack_input:
		var intro_hints = get_tree().get_first_node_in_group("IntroHints")
		if !attack_hint_shown:
			attack_hint_shown = true
			intro_hints.get_child(0).intro_popup()
		if event.is_action_pressed("attack"):
			if intro_hints.get_child(0).hint_showed:
				intro_hints.get_child(0).hint_showed = false
				intro_hints.get_child(0).intro_close()
			else:
				attack_input = false
				intro_hints.get_child(0).queue_free()
				player_swing()
	if ability1_input:
		var intro_hints = get_tree().get_first_node_in_group("IntroHints")
		if !ability1_hint_shown:
			ability1_hint_shown = true
			intro_hints.get_child(0).intro_popup()
		if event.is_action_pressed("attack"):
			if intro_hints.get_child(0).hint_showed:
				intro_hints.get_child(0).hint_showed = false
				intro_hints.get_child(0).intro_close()
		if event.is_action_pressed("ability1") and !intro_hints.get_child(0).hint_showed:
				player.add_charge()
				ability1_input = false
				intro_hints.get_child(0).queue_free()
				player_ability1()



signal do_action(action)
var attack_input : bool = false
func player_swing() -> void:
	do_action.emit("attack")
	await get_tree().create_timer(0.7).timeout
	play_intro3()

var ability1_input : bool = false
func player_ability1() -> void:
	do_action.emit("ability1")
	await get_tree().create_timer(0.7).timeout
	play_intro4()



func _start_phase1() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.in_cutscene = true
	player.set_process_input(false)
	move_player()



func move_player() -> void:
	var tween = create_tween()
	tween.tween_property(player, "global_position", get_tree().get_first_node_in_group("MovePosition").global_position, 1.0)
	await tween.finished
	balloon = BALLOON.instantiate()
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://cutscenes/phase1.dialogue"), "Phase1Start")
	player.set_physics_process(false)


#const BOSS_FIGHT = preload("res://levels/boss_fight.tscn")
func play_phase1_2() -> void:
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	balloon.start(load("res://cutscenes/phase1.dialogue"), "Phase1End")
	await DialogueManager.dialogue_ended



	#get_tree().get_first_node_in_group("Main").add_child(BOSS_FIGHT.instantiate())

func play_phase2_1() -> void:
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	balloon.start(load("res://cutscenes/phase2.dialogue"), "Phase2Start")
	await DialogueManager.dialogue_ended

func play_phase2_2() -> void:
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	character_label = balloon.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	balloon.start(load("res://cutscenes/phase2.dialogue"), "Phase2End")
	await DialogueManager.dialogue_ended


func color_akira() -> void:
	character_label.modulate = Color.PALE_VIOLET_RED

func color_riro() -> void:
	character_label.modulate = Color.SKY_BLUE

func color_kaguya() -> void:
	character_label.modulate = Color.REBECCA_PURPLE
