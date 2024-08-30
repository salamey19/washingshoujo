extends Area2D

var speed = 1150
@onready var sprite: Sprite2D = $pivot/Sprite2D
@onready var pivot: Node2D = $pivot
@onready var explosion_sfx: AudioStreamPlayer2D = $ExplosionSFX
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var choice : int = 0

const red = preload("res://art/2d/player/ONI charges/red.png")
const red_pos = Vector2(-14, 81)
const green = preload("res://art/2d/player/ONI charges/green.png")
const green_pos = Vector2(69, 27)
const yellow = preload("res://art/2d/player/ONI charges/yellow.png")
const yellow_pos = Vector2(-64, 48)

func _ready() -> void:
	if choice == 0:
		sprite.texture = green
		sprite.position = green_pos
		sprite.scale = Vector2(0.277, 0.277)
	elif choice == 1:
		sprite.texture = red
		sprite.position = red_pos
		sprite.scale = Vector2(0.222, 0.222)
	else:
		sprite.texture = yellow
		sprite.position = yellow_pos
		sprite.scale = Vector2(0.222, 0.222)

func _physics_process(delta):
	position += transform.x * speed * delta
	pivot.rotation += deg_to_rad(25)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		explosion()
		set_physics_process(false)
		collision_shape.set_deferred("disabled", true)
		area.damage(1)

		OS.delay_msec(150)
		pivot.visible = false
		get_tree().get_first_node_in_group("Camera").camera_shake(20)


func explosion() -> void:
	explosion_sfx.play()
	animated_sprite.play("explosion")
	await explosion_sfx.finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		queue_free()
