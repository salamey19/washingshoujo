extends CharacterBody2D

#Improts
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var abilities_animation_player: AnimationPlayer = $AbilitiesAnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var vfx: AnimatedSprite2D = $VFX


#movement
const SPEED = 425.0
const JUMP_VELOCITY = -400.0
const FALL_GRAVITY := 1500
const GRAVITY := 1000

#DASH
const DASH_SPEED = 2000
var dashed_this_beat : bool = false
var is_dashing : bool = false
var dash_time_max : float = 0.25
var dash_timer : float = 0.0
var dash_direction : float = 0
var dash_height : float = 0

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

const AFTERIMAGE = preload("res://components/player/afterimage.tscn")

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
		#animation_player.play("player_on_beat")


var is_left : bool = false
func _input(event: InputEvent) -> void:

	#handling character flipping
	if event.is_action_pressed('attack'):
		hurt()
		await animated_sprite.animation_finished

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




func get_grav(velocity: Vector2):

	if velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY


func _physics_process(delta: float) -> void:

	if BeatDirector.get_beat_offset(beat_index) < grace_min:
		is_on_beat = true
	elif BeatDirector.get_beat_offset(beat_index) >= grace_max:
		is_on_beat = true
	else:
		is_on_beat = false

	if is_dashing:
		position.y = dash_height
	else:
		if not is_on_floor():
			velocity.y += get_grav(velocity) * delta
		if Input.is_action_just_released("jump") and velocity.y < 0 and velocity.y <= (JUMP_VELOCITY / 2):
			velocity.y = JUMP_VELOCITY / 2
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY


	if velocity.x > 450 or velocity.x < -450:
		animated_sprite.play("dash")
	elif velocity.x <= 450 and velocity.x > 0:
		if !animated_sprite.is_playing():
			animated_sprite.play("idle")
	else:
		if !animated_sprite.is_playing():
			animated_sprite.play("idle")



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0 and !animated_sprite.flip_h:
		%VFX.flip_h = true
		animated_sprite.flip_h = true
		weapon.scale.x = 1
	if direction < 0 and animated_sprite.flip_h:
		%VFX.flip_h = false
		animated_sprite.flip_h = false
		weapon.scale.x = -1

	if !is_dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


	#dash stuff, should be able to dash once on every beat
	if Input.is_action_just_pressed("dash") and is_on_beat and !dashed_this_beat and !is_zero_approx(direction):
		dashed_this_beat = true
		print("dash")
		is_dashing = true
		dash_direction = direction
		dash_height = position.y
		dash_timer = 0

		charge_counter += 1
		if charge_counter >= 1:
			charge_counter = 0
			add_charge()
	elif Input.is_action_just_pressed("dash") and !is_on_beat and !dashed_this_beat:
		charge_counter = 0

	#handling dash
	if is_dashing:
		dash_timer += delta

	if is_dashing and dash_timer >= dash_time_max:
		is_dashing = false
		spawn_afterimage()
		do_once = false
		do_twice = false
		do_thrice = false
		print("dashing over")

	elif is_dashing and dash_timer <= dash_time_max:

		velocity.x += dash_direction * DASH_SPEED * delta
		#spawning afterimages
		if dash_timer >= dash_time_max / 4 and !do_once:
			do_once = true
			print("do-once")
			spawn_afterimage()
		elif dash_timer >= (dash_time_max / 2) and !do_twice:
			print("do-twice")
			do_twice = true
			spawn_afterimage()
			spawn_afterimage()
		elif dash_timer >= (dash_time_max / 2 + dash_time_max / 4) and !do_thrice:
			print("do-twice")
			do_thrice = true
			spawn_afterimage()
		#afterimage_counter += 1
		#if afterimage_counter == 5:
			#afterimage_counter = 0
			#spawn_afterimage()






	move_and_slide()


var do_once = false
var do_twice = false
var do_thrice = false
var afterimage_counter : int = 0
func spawn_afterimage() -> void:
	var afterInstance = load("res://components/player/afterimage.tscn").instantiate()
	afterInstance.position = position
	if dash_direction == 1:
		afterInstance.flip_h = true
	get_parent().add_child(afterInstance)

func hurt() -> void:
	animated_sprite.play("hurt")
	%VFX.play("knock_back")


signal charge_added
func add_charge() -> void:
	if not ((current_charges + 1) > MAX_CHARGES):
		current_charges += 1
		charge_added.emit()
