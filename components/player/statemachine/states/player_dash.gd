extends State
class_name PlayerDash

@onready var dash_sfx: AudioStreamPlayer = $"../../DashSFX"

@onready var dash_voice: AudioStreamPlayer2D = $"../../Voice/Dash"

func Enter():
	player.animated_sprite.play("dash_start")
	dash_sfx.play()
	await player.animated_sprite.animation_finished
	dash_voice.play()
	player.animated_sprite.play("dash")
	player.has_dash = false
	dash()


func Exit():
	player.is_dashing = false
	#dash_sfx.stop()
	player.spawn_afterimage()
	player.do_once = false
	player.do_twice = false
	player.do_thrice = false
	if !player.is_on_floor():
		player.velocity.y = -205



func Physics_Update(delta : float):
	if player.is_hurt:
		Transitioned.emit(self, "hurt")


		#handling dash
	if player.is_dashing:
		player.dash_timer += delta

	if player.is_dashing and player.dash_timer >= player.dash_time_max:
		if player.is_hurt:
			Transitioned.emit(self, "hurt")
		if !player.is_on_floor():
			Transitioned.emit(self, "falling")

		if player.velocity.x > 0 or player.velocity.x < 0:
			Transitioned.emit(self, "run")
		else:
			Transitioned.emit(self, "idle")

		print("dashing over")

	elif player.is_dashing and player.dash_timer <= player.dash_time_max:

		player.velocity.x += player.dash_direction * player.DASH_SPEED * delta
		#spawning afterimages
		if player.dash_timer >= player.dash_time_max / 4 and !player.do_once:
			player.do_once = true
			print("do-once")
			player.spawn_afterimage()
		elif player.dash_timer >= (player.dash_time_max / 2) and !player.do_twice:
			print("do-twice")
			player.do_twice = true
			player.spawn_afterimage()
			#spawn_afterimage()
		elif player.dash_timer >= (player.dash_time_max / 2 + player.dash_time_max / 4) and !player.do_thrice:
			print("do-twice")
			player.do_thrice = true
			player.spawn_afterimage()
		#afterimage_counter += 1
		#if afterimage_counter == 5:
			#afterimage_counter = 0
			#spawn_afterimage()


func Handle_Input(event: InputEvent):
	if event.is_action_pressed("jump") and (player.has_jump or player.has_double_jump):
		Transitioned.emit(self, "jump")


func dash() -> void:
	print("dash")
	player.is_dashing = true

	player.dash_height = player.position.y
	player.dash_timer = 0

	player.charge_counter += 1
	if player.charge_counter >= 1:
		player.charge_counter = 0
		player.add_charge()
