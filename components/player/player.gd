extends CharacterBody2D


#ideas balls act as charges up to 3
#charges can block damage, but lose charge
#charges can be used for abilities


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 800
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_on_beat : bool = true
var beat_index : int = 0
var current_index : int = 0

func _ready() -> void:
	BeatDirector.beat.connect(on_beat)
	BeatDirector.play_song("peritune_scene_tragic")


func on_beat(index) -> void:

	if !(index % 3):
		beat_index = index
		#print(index)
		is_on_beat = true
		animation_player.play("player_on_beat")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#print(beat_index)
	#print(BeatDirector.get_beat_offset(beat_index))
	if BeatDirector.get_beat_offset(beat_index) < .3:
		is_on_beat = true
		#print("early")
		#print("bad")
	elif BeatDirector.get_beat_offset(beat_index) >= .9:
		is_on_beat = true
		#print("delay")
	else:
		is_on_beat = false
		#print("good")

	if is_on_beat:
		print("dash")
	else:
		print("noot")
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	#dash stuff, should be able to dash on every beat
	if Input.is_action_just_pressed("dash") and is_on_beat:
		print("dash")
		velocity.x = direction * 3 * DASH_SPEED

	move_and_slide()
