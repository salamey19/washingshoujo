extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var attack_sprite: AnimatedSprite2D = $VFX/AttackSprite
@export var attack_cooldown : float = 0


@onready var attack_collision: CollisionShape2D = $AttackArea/CollisionShape2D

var within_range : bool = false
var player : CharacterBody2D
var stop_aiming : bool = false
var is_attacking : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_sprite.visible = false
	attack_collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	#follow player and attack within range
	if within_range:
		attack_cooldown += delta

		if !stop_aiming:
			look_at(player.position)
		if rotation < deg_to_rad(-270):
			scale.y = -1
		elif rotation > deg_to_rad(-90) and rotation < deg_to_rad(90):
			scale.y = -1
		elif rotation > deg_to_rad(90):
			scale.y = 1
		elif rotation >= deg_to_rad(-270):
			scale.y = 1
		if rotation >= deg_to_rad(360) or rotation <= deg_to_rad(-360):
			rotation = rad_to_deg(0)

		if attack_cooldown >= 4 and !is_attacking:
			attack()




func attack() -> void:
	is_attacking = true
	attack_sprite.visible = true
	enemy_sprite.visible = true
	enemy_sprite.play("blink_attack")
	attack_sprite.play("attack")
	await get_tree().create_timer(0.25)
	stop_aiming = true
	await get_tree().create_timer(0.5).timeout
	print("red part")
	attack_collision.disabled = false
	await attack_sprite.animation_finished
	var rng = RandomNumberGenerator.new()
	attack_sprite.visible = false
	attack_cooldown = rng.randf_range(0, 1)
	stop_aiming = false
	is_attacking = false
	attack_collision.disabled = true
	await enemy_sprite.animation_finished

@onready var ghost_sprite: Sprite2D = $GhostSprite

func set_ghost_progress(val: float):
	ghost_sprite.material.set("shader_parameter/ghost_progress", val)

func death() -> void:
	set_process(false)
	enemy_sprite.play("death")
	ghost_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_ghost_progress, 0.0, 1.0, 1.0)
	tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y - 30, 1)
	await tween.finished
	queue_free()



func _on_within_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		within_range = true
		attack_cooldown = 1


func _on_within_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.damaged()


func _on_body_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.damaged()
