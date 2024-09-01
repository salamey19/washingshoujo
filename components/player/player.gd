extends CharacterBody2D

#Improts
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var abilities_animation_player: AnimationPlayer = $AbilitiesAnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var charges: Node2D = $Weapon/Charges


#@onready var vfx: AnimatedSprite2D = $VFX
@onready var vfx: AnimatedSprite2D = %VFX

#health
var is_hurt : bool = false
var can_be_hurt : bool = true
const MAX_LIVES : int = 3
var current_lives : int = 3

#movement
const SPEED = 425.0
const JUMP_VELOCITY = -650.0
const FALL_GRAVITY := 1000
const GRAVITY := 800

#jump
var has_jump : bool = false
var has_double_jump : bool = true
var jump_buffer : float = 0.1

#DASH
var has_dash : bool = true
const DASH_SPEED = 2000
var dashed_this_beat : bool = false
var is_dashing : bool = false
var dash_time_max : float = 0.25
var dash_timer : float = 0.0
var dash_direction : float = 0
var dash_height : float = 0

var do_once = false
var do_twice = false
var do_thrice = false
var afterimage_counter : int = 0


#ideas balls act as charges up to 3
#charges can block damage, but lose charge
#charges can be used for abilities
#regain a charge automatically every x beat??

#combo stuff
var current_combo : int = 0
var combo_speed : float = 0


var is_transformed : bool = false



#Abilities
const MAX_CHARGES = 3
@onready var current_charges : int = 0
@onready var charge_counter : int = 0
@onready var weapon: Node2D = $Weapon
var ability_2_damage : int = 0
const AFTERIMAGE = preload("res://components/player/afterimage.tscn")

var has_basic_attack : bool = true


var locked : bool = false
var locked_height : float = 0

var should_fall : bool = true
var using_ability : bool = false


var is_left : bool = false


func _ready() -> void:
	Global.enemy_defeated.connect(on_enemy_defeated)
	current_lives = MAX_LIVES

func _input(event: InputEvent) -> void:

	#if event.is_action_pressed("jump"):
		#has_jump = false

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




func get_grav(velocity: Vector2):

	if velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY


func _physics_process(delta: float) -> void:
	#print(velocity.y)
	#print("has jump: ",has_jump)


	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0.1
	jump_buffer -= delta

	if is_on_floor() and current_combo == 0:
		stop_combo()

	if locked:
		position.y = locked_height

	if is_dashing:
		position.y = dash_height
	else:
		if not is_on_floor() and should_fall:
			velocity.y += get_grav(velocity) * delta



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0 and !animated_sprite.flip_h:
		vfx.flip_h = true
		vfx.position.x = absf(vfx.position.x)
		animated_sprite.flip_h = true
		weapon.scale.x = 1
	if direction < 0 and animated_sprite.flip_h:
		vfx.flip_h = false

		vfx.position.x = absf(vfx.position.x) * -1
		animated_sprite.flip_h = false
		weapon.scale.x = -1

	if !is_dashing:
		if direction and !using_ability:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)



	if Input.is_action_just_pressed("dash"):
		dash_direction = direction
	if is_on_floor() and !has_jump:
		has_jump = true
		has_double_jump = true
	if is_on_floor() and !has_dash:
		has_dash = true
	if is_on_floor() and !has_basic_attack:
		has_basic_attack = true
	move_and_slide()


func on_enemy_defeated() -> void:
	has_double_jump = true
	has_dash = true
	add_charge()
	add_combo()




func add_combo() -> void:
	current_combo +1
	combo_speed += 5
	get_tree().get_first_node_in_group("Combo").text = str(int(get_tree().get_first_node_in_group("Combo").text) + 1)


func stop_combo() -> void:
	current_combo = 0
	combo_speed = 0
	get_tree().get_first_node_in_group("Combo").text = "0"


func spawn_afterimage() -> void:
	var afterInstance = load("res://components/player/afterimage.tscn").instantiate()
	afterInstance.position = position
	afterInstance.texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
	if !is_left:
		afterInstance.flip_h = true
	if dash_direction == 1:
		afterInstance.flip_h = true
	get_parent().add_child(afterInstance)


func damaged() -> void:
	if can_be_hurt:
		is_hurt = true


var kb_force = 1200
func hurt() -> void:
	Global.player_hurt.emit()
	current_lives -= 1
	get_tree().get_first_node_in_group("Lives").lose_life()
	if current_lives < 1:
		death()
	else:
		var kb_direction = -1
		if is_left:
			kb_direction = 1

		get_tree().get_first_node_in_group("Camera").camera_shake(10)
		var kb = (Vector2(500 * kb_direction, 500) - velocity).normalized() * kb_force
		velocity.x = kb.x
		print(velocity)
		animated_sprite.play("hurt")
		animation_player.play("flash_red")
		#velocity.y -= 300
		if is_on_floor():
			%VFX.play("knock_back")
		move_and_slide()

		await animated_sprite.animation_finished
		is_hurt = false
		animation_player.play("immune_flash")
		can_be_hurt = false
		await animation_player.animation_finished
		can_be_hurt = true

func death():
	print("death")
	Global.restart_level()

func lock_player() -> void:
	locked_height = position.y
	locked = true

func unlock_player() -> void:
	locked = false
	locked_height = 0

func attack_bounce() -> void:
	if !is_on_floor():
		velocity.y -= 250

signal charge_added
func add_charge() -> void:
	if not ((current_charges + 1) > MAX_CHARGES):
		current_charges += 1
		charge_added.emit()
