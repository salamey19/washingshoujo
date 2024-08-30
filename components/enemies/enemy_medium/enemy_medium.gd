extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@export var attack_cooldown : float = 4
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox_component: Area2D = $Pivot/HurtboxComponent
@onready var ghost_sprite: Sprite2D = $GhostSprite
@onready var hitbox_component: Area2D = $HitboxComponent
@onready var pivot: Node2D = $Pivot
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_sfx: AudioStreamPlayer2D = $AttackSFX
@onready var death_sfx: AudioStreamPlayer2D = $DeathSFX

@onready var flag_collision1: CollisionShape2D = $Pivot/HurtboxComponent/CollisionShape2D
@onready var flag_collision2: CollisionShape2D = $Pivot/HurtboxComponent2/CollisionShape2D

@export var patrol_point_1 : Node2D
@export var patrol_point_2 : Node2D

var within_range : bool = false

var rng = RandomNumberGenerator.new()

var attack_timer : float = 0.0
var attacking : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if attacking:
		attack_timer += delta

	if within_range:
		attack_cooldown += delta

	if within_range and attack_cooldown >= 5:
		attack()
		attack_cooldown = rng.randf_range(2, 3)


func attack() -> void:
	attacking = true
	enemy_sprite.play("attack")
	await get_tree().create_timer(0.75).timeout
	animation_player.play("attack")
	attack_sfx.play()
	await enemy_sprite.animation_finished
	flag_collision2.disabled = true
	flag_collision1.disabled = true
	attacking = false
	print(attack_timer)
	attack_timer = 0
	enemy_sprite.play("blink_idle")

func set_ghost_progress(val: float):
	ghost_sprite.material.set("shader_parameter/ghost_progress", val)


func death() -> void:

	hurtbox.queue_free()
	hitbox_component.queue_free()
	animation_player.call_deferred("stop")
	pivot.queue_free()
	Global.enemy_defeated.emit()

	set_process(false)
	enemy_sprite.offset.x = 750
	death_sfx.play()
	enemy_sprite.play("death")
	ghost_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_ghost_progress, 0.0, 1.0, 1.0)
	tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y + 30, 1)
	await tween.finished
	queue_free()



func _on_within_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = true

func _on_within_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = false
