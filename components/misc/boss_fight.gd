extends Node2D

@export var boss : Node2D

@export_category("Phase1")
@export var barrier : Node2D
var barrier_active : bool = true
@export var barrier_enemy1 : Node2D
@export var barrier_enemy2 : Node2D
var phase1_health : int = 10

@export_category("Phase2")
var attack_time : float = 20
var is_damage_phase : bool = false
var damage_phase_time : float = 15
@onready var boss_background: Sprite2D = $ParallaxBackground/ParallaxLayer/BossBackground
@onready var landing_vfx: AnimatedSprite2D = $VFX/LandingVFX


@export_category("Attacks")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if barrier_active:
		if !barrier_enemy1 and !barrier_enemy2:
			barrier_active = false
			barrier.queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ability1"):
		phase2_start()

func phase1_start():
	pass

func phase2_start():
	boss.jump_up()
	boss_background.visible = true
	var tween = create_tween()
	tween.tween_property(boss_background, "position:y", 193, 0.7)
	await tween.finished
	get_tree().get_first_node_in_group("Camera").camera_shake(200)
	landing_vfx.play()

func long_cut() -> void:
	pass

func short_cuts() -> void:
	pass

func eye_attack() -> void:
	pass
