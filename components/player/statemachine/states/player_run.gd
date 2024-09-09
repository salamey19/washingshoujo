extends State
class_name PlayerRun


@onready var water: AudioStreamPlayer2D = $"../../SFX/Steps/Water"
@onready var rock: AudioStreamPlayer2D = $"../../SFX/Steps/Rock"
@onready var metal: AudioStreamPlayer2D = $"../../SFX/Steps/Metal"
@onready var concrete: AudioStreamPlayer2D = $"../../SFX/Steps/Concrete"

var floor_sound : String
var play_metal : bool = true
var play_metal_timer : float = 0
func _ready() -> void:
	Global.player_floor_sound.connect(_change_floor_sound)


func Enter():
	player.animated_sprite.play("run")


func Physics_Update(delta : float):

	if player.is_hurt:
		Transitioned.emit(self, "hurt")


	if !play_metal:
		play_metal_timer += delta
		if play_metal_timer >= 0.3:
			play_metal = true
			play_metal_timer = 0
	if player.is_on_floor():
		if floor_sound == "WATER" and !water.playing:
			water.play()
		elif floor_sound == "ROCK" and !rock.playing:
			await get_tree().create_timer(0.2).timeout
			rock.play()
		elif floor_sound == "METAL" and play_metal and !metal.playing:
			metal.play()
			play_metal = false
		elif floor_sound == "CONCRETE" and !concrete.playing:
			concrete.play()
	if player.jump_buffer > 0 and player.has_jump:
		Transitioned.emit(self, "jump")
	if is_zero_approx(player.velocity.x):
		Transitioned.emit(self, "idle")
	if player.velocity.y > 0.0 :
		Transitioned.emit(self, "falling")

func Handle_Input(event: InputEvent):

	if !player.in_cutscene:
		if event.is_action_pressed("dash"):
			Transitioned.emit(self, "dash")
		if event.is_action_pressed("attack") and player.has_basic_attack:
			Transitioned.emit(self, "attack")
		if player.current_charges > 0:
			if event.is_action_pressed("ability1"):
				Transitioned.emit(self, "ability1")
			if event.is_action_pressed("ability2"):
				Transitioned.emit(self, "ability2")

func _change_floor_sound(floor) -> void:
	floor_sound = floor
