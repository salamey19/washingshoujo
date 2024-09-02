extends Node2D

@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var vfx: AnimatedSprite2D = $VFX

@onready var jump_up_sfx: AudioStreamPlayer2D = $Node2D/JumpUpSFX
@onready var jump_down_sfx: AudioStreamPlayer2D = $Node2D/JumpDownSFX
@onready var jump_down_rubble_sfx: AudioStreamPlayer2D = $Node2D/JumpDownRubbleSFX

var delta_temp : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta_temp = delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		jump_up()
	if event.is_action_pressed("ability1"):
		jump_down()


func move_up(value: float) -> void:
	enemy_sprite.position.y += value * delta_temp

func jump_up() -> void:
	vfx.play("jump_up_vfx")
	jump_up_sfx.play(0.0)
	enemy_sprite.play("jump_up")
	var tween = create_tween()
	tween.tween_method(move_up, -4000, -1, 0.9)

func jump_down() -> void:

	enemy_sprite.play("jump_down")
	var tween = create_tween()
	tween.tween_method(move_up, 4000, -1, 0.9)
	await tween.finished
	vfx.play("jump_down_vfx")
	jump_down_sfx.play()
	jump_down_rubble_sfx.play()
	enemy_sprite.play("hurt")
