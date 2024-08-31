extends Node2D

@export_category("Phase1")
@export var barrier : Node2D
var barrier_active : bool = true
@export var barrier_enemy1 : TankEnemy
@export var barrier_enemy2 : TankEnemy
var phase1_health : int = 10

@export_category("Phase2")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if barrier_active:
		if !barrier_enemy1 and !barrier_enemy2:
			barrier_active = false
			barrier.queue_free()
