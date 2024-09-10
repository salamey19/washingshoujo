extends Node2D

@export var boss : Node2D
var player : CharacterBody2D

@export_category("Phase1")
@onready var barrier_collision: CollisionShape2D = $Phase1/Barrier/CollisionShape2D
@onready var barrier: StaticBody2D = $Phase1/Barrier

var barrier_active : bool = true
@export var barrier_enemy1 : Node2D
@export var barrier_enemy2 : Node2D
var phase1_health : int = 10

@export_category("Phase2")
var is_attack_phase : bool = false
var is_damage_phase : bool = false
@onready var boss_background: Sprite2D = $ParallaxBackground/ParallaxLayer/BossBackground
@onready var landing_vfx: AnimatedSprite2D = $VFX/LandingVFX
var is_phase2_1 : bool = true
var is_phase2_2 : bool = false
var is_phase2_3 : bool = false
@export_category("Attacks")
@onready var health_bar: ProgressBar = $Phase2/CanvasLayer/HealthBarOutline/HealthBar

var is_attacking : bool = false
var attack_finished : bool = false

var attack_cooldown : float = 3
var attack_counter : int = 0

var attacks_available : Array[bool] = [true, true, true]

@onready var boss_music: AudioStreamPlayer = $BossMusic

func _ready() -> void:
	Global.boss_hurt.connect(_boss_hurt)
	CutsceneManager.start_phase1_boss.connect(phase1_start)
	CutsceneManager.start_phase2.connect(phase2_start)
	CutsceneManager.boss_jump.connect(phase2_jump)
	Global.boss_fight_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if barrier_active:
		if !barrier_enemy1 and !barrier_enemy2:
			barrier_active = false
			barrier.queue_free()

func _physics_process(delta: float) -> void:
	if is_attack_phase:
		attack_cooldown -= delta
		if is_phase2_1:
			if attack_cooldown <= 0:
				print("attack")
				choose_attack()
				attack_cooldown = 3
				attack_counter += 1
			if attack_counter == 5:
				is_attack_phase = false
				start_damage_phase()
				attack_counter = 0
		elif is_phase2_2:
			if attack_cooldown <= 0:
				attack_cooldown = 4
				print("attack")
				choose_attack()
				await get_tree().create_timer(0.7).timeout
				choose_attack()
				attack_counter += 1
			if attack_counter == 6:
				is_attack_phase = false
				start_damage_phase()
				attack_counter = 0
		elif is_phase2_3:
			if attack_cooldown <= 0:
				attack_cooldown = 4
				print("attack")
				choose_attack()
				await get_tree().create_timer(0.7).timeout
				choose_attack()
				attack_counter += 1
			if attack_counter == 7:
				attack_counter = 0
				is_attack_phase = false
				start_damage_phase()





func phase1_start():
	Global.boss_checkpoint_met = true
	barrier_collision.disabled = false
	#set sprite visible




func phase2_jump():
	boss.turn_off()
	boss.jump_up()

func phase2_start():

	await get_tree().create_timer(0.2).timeout
	boss_background.visible = true
	var tween = create_tween()
	tween.tween_property(boss_background, "position:y", 193, 0.7)
	await tween.finished
	get_tree().get_first_node_in_group("Camera").camera_shake(200)
	landing_vfx.play()
	await get_tree().create_timer(1.0).timeout
	#do cutscene then start attack phase

	await get_tree().create_timer(1.0).timeout
	is_attack_phase = true
	boss_music.play()
	%HealthBarOutline.show()

func start_attack_phase():
	boss.jump_up()
	await get_tree().create_timer(0.7).timeout
	boss_background.visible = true
	var tween = create_tween()
	tween.tween_property(boss_background, "position:y", 193, 0.7)
	await tween.finished
	get_tree().get_first_node_in_group("Camera").camera_shake(200)
	landing_vfx.play()
	await get_tree().create_timer(1.0).timeout
	is_attack_phase = true


func start_damage_phase():

	var tween = create_tween()
	tween.tween_property(boss_background, "position:y", -2750, 0.7)
	await get_tree().create_timer(2.0).timeout
	boss_background.visible = false
	boss.jump_down()
	is_damage_phase = true


func _boss_hurt() -> void:
	health_bar.set_health(health_bar.health - 1)
	print("health = ",health_bar.health)
	if health_bar.health == 6:
		is_phase2_1 = false
		is_phase2_2 = true
		is_damage_phase = false
		boss.turn_off()
		start_attack_phase()
	elif health_bar.health == 3:
		is_phase2_3 = true
		is_phase2_2 = false
		is_damage_phase = false
		boss.turn_off()
		start_attack_phase()
	elif health_bar.health == 0:
		is_damage_phase = false
		boss.turn_off()
		boss_death()


func boss_death() -> void:
	#play ending cutscene
	boss_music.stop()
	%HealthBarOutline.hide()
	CutsceneManager.play_phase2_2()
	#end game/credits
	#boss.queue_free()


var rng = RandomNumberGenerator.new()
func choose_attack() -> void:
	var chosen = rng.randi_range(0, 2)
	while !attacks_available[chosen]:
		chosen = rng.randi_range(0, 2)
	attacks_available[chosen] = false
	if chosen == 0:
		short_cuts()
	elif chosen == 1:
		long_cut()
	elif chosen == 2:
		eye_attack()

func short_cuts() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if is_phase2_1:
		%SliceFollowAttack.global_position = player.global_position
		await get_tree().create_timer(0.1).timeout
		%SliceFollowAttack.attack3()
	if is_phase2_2:
		%SliceFollowAttack.global_position = player.global_position
		await get_tree().create_timer(0.1).timeout
		%SliceFollowAttack.attack3()
		await get_tree().create_timer(1.4).timeout
		%SliceFollowAttack.global_position = player.global_position
		await get_tree().create_timer(0.1).timeout
		%SliceFollowAttack.attack2()
	if is_phase2_3:
		%SliceFollowAttack.global_position = player.global_position
		await get_tree().create_timer(0.1).timeout
		%SliceFollowAttack.attack3()
		await get_tree().create_timer(1.4).timeout
		%SliceFollowAttack.global_position = player.global_position
		await get_tree().create_timer(0.1).timeout
		%SliceFollowAttack.attack2()
		await get_tree().create_timer(1.4).timeout
		%SliceFollowAttack.global_position = player.global_position
		await get_tree().create_timer(0.1).timeout
		%SliceFollowAttack.attack1()
		await get_tree().create_timer(1.4).timeout
		attack_finished = true
	attacks_available[0] = true


func long_cut() -> void:

	if is_phase2_1:
		%ScreenSlashAttack.position.y = -562
		%ScreenSlashAttack.attack()
	if is_phase2_2:
		%ScreenSlashAttack.position.y = -352
		%ScreenSlashAttack.attack()
		await get_tree().create_timer(1.6).timeout
		%ScreenSlashAttack.position.y = -562
		%ScreenSlashAttack.attack()
	if is_phase2_3:
		%ScreenSlashAttack.position.y = -352
		%ScreenSlashAttack.attack()
		await get_tree().create_timer(1.6).timeout
		%ScreenSlashAttack.position.y = -562
		%ScreenSlashAttack.attack()
		await get_tree().create_timer(1.6).timeout
		%ScreenSlashAttack.position.y = -781
		%ScreenSlashAttack.attack()
	attacks_available[1] = true


func eye_attack() -> void:

	if is_phase2_1:
		%EyeAttack.animation_player.speed_scale = 0.6
	if is_phase2_2:
		%EyeAttack.animation_player.speed_scale = 0.8
	if is_phase2_3:
		%EyeAttack.animation_player.speed_scale = 1.0
	%EyeAttack.attack()


	attacks_available[2] = true

var done : bool = false
func _on_start_phase_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !done:
		done = true
		CutsceneManager.play_phase2_1()
