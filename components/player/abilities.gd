extends Node2D


#Handling abilities and attacks here

@onready var player: CharacterBody2D = $".."

@onready var ability_used_this_beat : bool = false
@onready var charges: Node2D = $Charges

const FAMILIAR = preload("res://components/player/familiar.tscn")
@onready var familiar_pos_1 : Vector2 = Vector2(-42, -36)
@onready var familiar_pos_2 : Vector2 = Vector2(0, -45)
@onready var familiar_pos_3 : Vector2 = Vector2(42, -36)


@onready var basic_attack_area: Area2D = $BasicAttackArea
@export var basic_attack_damage : int = 1


func _ready() -> void:
	player.player_on_beat.connect(on_beat_weapon)
	player.charge_added.connect(on_charge_added)


func on_beat_weapon() -> void:
	ability_used_this_beat = false


var child_temp : int = 0
#handle adding familiars here
func on_charge_added() -> void:
	charges.add_child(FAMILIAR.instantiate())
	child_temp = charges.get_child_count() - 1

	#based on child, change position
	if child_temp == 0:
		charges.get_child(child_temp).visible = true
	elif child_temp == 1:
		charges.get_child(child_temp).position = familiar_pos_2
		charges.get_child(child_temp).visible = true
	elif child_temp == 2:
		charges.get_child(child_temp).position = familiar_pos_3
		charges.get_child(child_temp).visible = true
	else:
		print("Error: overloaded the children")



#tie ability speed to bpm??
func _unhandled_input(event: InputEvent) -> void:

	if player.is_on_beat and !ability_used_this_beat:
		if event.is_action_pressed("attack"):
			#do basic attack bonk
			print("basic attack")
			ability_used_this_beat = true
		if player.current_charges > 0:
			if event.is_action_pressed("ability1"):
				print("ability1")
				player.current_charges -= 1
				charges.remove_child(charges.get_child(0))

				ability_used_this_beat = true
			if event.is_action_pressed("ability2"):
				print("ability2")
				player.current_charges = 0
				ability_used_this_beat = true


func shuffle_children() -> void:
	#if get
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#if trans deal more damage? maybe
func _on_basic_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		if body.has_method("hurt"):
			body.hurt(basic_attack_damage)
