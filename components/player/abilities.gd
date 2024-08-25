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
@onready var ability_1_marker: Marker2D = $Ability1Marker


func _ready() -> void:
	player.charge_added.connect(on_charge_added)

var child_temp : int = 0
#handle adding familiars here
func on_charge_added() -> void:
	print("Charge added")
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




func shuffle_children() -> void:
	#if get
	pass





#if trans deal more damage? maybe

func _on_basic_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if area.has_method("damage"):
			area.damage(basic_attack_damage)


func _on_ability_2_areas_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if area.has_method("damage"):
			area.damage(player.ability_2_damage)
