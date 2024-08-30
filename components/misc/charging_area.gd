extends Area2D

var within_range : bool = false
@export var charge_amount : int = 0
var charge_delay : float = 0
@export var charge_delay_max : float = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if within_range:
		if get_tree().get_first_node_in_group("Player").current_charges < charge_amount:
			if charge_delay > charge_delay_max:
				charge_delay = 0
				get_tree().get_first_node_in_group("Player").add_charge()
		charge_delay += delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = true
		charge_delay = 0


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		within_range = false
