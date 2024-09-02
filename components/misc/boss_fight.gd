extends Node2D

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

@export_category("Attacks")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if barrier_active:
		if !barrier_enemy1 and !barrier_enemy2:
			barrier_active = false
			barrier.queue_free()

func phase1_start():
	pass

func phase2_start():
	pass

func long_cut() -> void:
	pass

func short_cuts() -> void:
	pass

func eye_attack() -> void:
	pass
