extends CharacterBody2D

#Improts
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var abilities_animation_player: AnimationPlayer = $AbilitiesAnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


#movement
const SPEED = 425.0
const JUMP_VELOCITY = -400.0

#DASH
const DASH_SPEED = 800
var dashed_this_beat : bool = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

#beat stuff
var is_on_beat : bool = true
var beat_index : int = 0
var current_index : int = 0
@export var grace_max : float = 0.9
@export var grace_min : float = 0.3

#ideas balls act as charges up to 3
#charges can block damage, but lose charge
#charges can be used for abilities
#regain a charge automatically every x beat??

var is_transformed : bool = false

#Abilities
const MAX_CHARGES = 3
@onready var current_charges : int = 0
@onready var charge_counter : int = 0
@onready var weapon: Node2D = $Weapon


func _ready() -> void:
	BeatDirector.beat.connect(on_beat)
	BeatDirector.play_song("peritune_scene_tragic")
	animated_sprite.play("idle")


signal player_on_beat
func on_beat(index) -> void:

	if !(index % 3):
		dashed_this_beat = false
		beat_index = index
		#print(index)
		is_on_beat = true
		player_on_beat.emit()
		animation_player.play("player_on_beat")


var is_left : bool = false
func _input(event: InputEvent) -> void:

	#handling character flipping

	if event.is_action_pressed("move_right") and is_left:
		is_left = false
		print("right")
		weapon.scale.x = -1
		#animated_sprite.flip_h = true
	if event.is_action_pressed("move_left") and !is_left:
		if scale.x != -1:
			is_left = true
			print("scale")
			#weapon.scale.x = -1
			#animated_sprite.flip_h = false


func _physics_process(delta: float) -> void:

	if BeatDirector.get_beat_offset(beat_index) < grace_min:
		is_on_beat = true
	elif BeatDirector.get_beat_offset(beat_index) >= grace_max:
		is_on_beat = true
	else:
		is_on_beat = false

	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0 and !animated_sprite.flip_h:
		animated_sprite.flip_h = true
		weapon.scale.x = 1
	if direction < 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
		weapon.scale.x = -1

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	#dash stuff, should be able to dash once on every beat
	if Input.is_action_just_pressed("dash") and is_on_beat and !dashed_this_beat:
		dashed_this_beat = true
		print("dash")
		velocity.x = direction * 3 * DASH_SPEED
		charge_counter += 1
		print(charge_counter)
		if charge_counter >= 3:
			charge_counter = 0
			add_charge()
	elif Input.is_action_just_pressed("dash") and !is_on_beat and !dashed_this_beat:
		charge_counter = 0
		print(charge_counter)


	move_and_slide()


signal charge_added
func add_charge() -> void:
	if not ((current_charges + 1) > MAX_CHARGES):
		current_charges += 1
		charge_added.emit()
