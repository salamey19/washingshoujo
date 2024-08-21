extends Node2D


#Handling abilities and attacks here

@onready var player: CharacterBody2D = $".."

@onready var ability_used_this_beat : bool = false
@onready var charges: Node2D = $Charges

const FAMILIAR = preload("res://components/player/familiar.tscn")
const ABILITY_1_PROJECTILE = preload("res://components/player/ability_1_projectile.tscn")
@onready var familiar_pos_1 : Vector2 = Vector2(-42, -36)
@onready var familiar_pos_2 : Vector2 = Vector2(0, -45)
@onready var familiar_pos_3 : Vector2 = Vector2(42, -36)


@onready var basic_attack_area: Area2D = $BasicAttackArea
@export var basic_attack_damage : int = 1
@onready var ability_1_marker: Marker2D = $Ability1Marker

var ability_2_damage : int = 0

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
			if player.abilities_animation_player.is_playing():
				player.abilities_animation_player.stop()
			print("basic attack")
			player.abilities_animation_player.play("basic_attack")
			ability_used_this_beat = true
		if player.current_charges > 0:
			if event.is_action_pressed("ability1"):
				print("ability1")
				swing()
				ability_used_this_beat = true
			if event.is_action_pressed("ability2"):
				ability_2(player.current_charges)
				player.current_charges = 0
				ability_used_this_beat = true


func shuffle_children() -> void:
	#if get
	pass

func ability_2(charge_amount) -> void:

	if charge_amount == 1:
		ability_2_damage = 1
		player.abilities_animation_player.play("ability2_level_1")
		print("ability_2_level_1")
	elif charge_amount == 2:
		ability_2_damage = 2
		player.abilities_animation_player.play("ability2_level_2")
		print("ability_2_level_2")
	elif charge_amount == 3:
		player.abilities_animation_player.play("ability2_level_3")
		ability_2_damage = 3
		print("ability_2_level_3")


	for charge in charges.get_child_count():
		charges.remove_child(charges.get_child(0))


func swing() -> void:
	player.current_charges -= 1
	charges.remove_child(charges.get_child(0))
	var b = ABILITY_1_PROJECTILE.instantiate()
	get_parent().get_parent().add_child(b)
	b.transform = $Ability1Marker.global_transform

#if trans deal more damage? maybe

func _on_basic_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if area.has_method("damage"):
			area.damage(basic_attack_damage)


func _on_ability_2_areas_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if area.has_method("damage"):
			area.damage(ability_2_damage)
