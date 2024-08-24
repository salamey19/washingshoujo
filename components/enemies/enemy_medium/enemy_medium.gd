extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@export var attack_cooldown : float = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
		attack_cooldown = rng.randf_range(0, 1)


func attack() -> void:
	attacking = true
	enemy_sprite.play("attack")
	animation_player.play("attack")
	await enemy_sprite.animation_finished
	attacking = false
	print(attack_timer)
	attack_timer = 0
	enemy_sprite.play("blink_idle")


func _on_within_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = true
		attack_cooldown = 4

func _on_within_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = false
