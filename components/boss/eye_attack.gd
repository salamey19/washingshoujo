extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot: Node2D = $pivot
@onready var marker: Marker2D = $pivot/Marker
@onready var marker2: Marker2D = $pivot/Marker2
@onready var marker3: Marker2D = $pivot/Marker3

@onready var ray_cast: RayCast2D = $pivot/RayCast2D
@onready var attack_sfx: AudioStreamPlayer2D = $AttackSFX

var phase1 : bool = true
var phase2 : bool = true
var phase3 : bool = true

var timer : float = 0
const EYE_PROJECTILE = preload("res://components/boss/eye_projectile.tscn")

func attack() -> void:

	animation_player.play("attack")



func _physics_process(delta: float) -> void:
	if animation_player.is_playing():
		timer += delta
		pivot.rotation += deg_to_rad(1)
		$EyeAttackVFX.rotation += deg_to_rad(1)
		if timer > 5:
			timer = 0
			animation_player.stop()
			$EyeAttackVFX.visible = false

func spawn_projectile() -> void:
	var projectile = EYE_PROJECTILE.instantiate()
	projectile.global_transform = marker.global_transform
	projectile.global_position = marker.position
	add_child(projectile)
	attack_sfx.play()
	if phase2:
		var projectile2 = EYE_PROJECTILE.instantiate()
		projectile2.global_transform = marker2.global_transform
		projectile2.global_position = marker2.position
		add_child(projectile2)
	if phase3:
		var projectile3 = EYE_PROJECTILE.instantiate()
		projectile3.global_transform = marker3.global_transform
		projectile3.global_position = marker3.position
		add_child(projectile3)
