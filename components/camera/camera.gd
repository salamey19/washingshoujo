extends Camera2D




var current_room : Vector2 = Vector2.ZERO

const HORIZONTAL_OFFSET : int = 56
const VERTICAL_OFFSET : int = 64


@export var target_node : Node2D = null

@onready var camera_horizontal_movement : int = get_viewport_rect().size.x - HORIZONTAL_OFFSET
@onready var camera_vertical_movement : int = get_viewport_rect().size.y - VERTICAL_OFFSET


var origin_offset : Vector2 = Vector2.ZERO

func _ready() -> void:
	#origin_offset = target_node.get_position()
	set_position(origin_offset)
	print(origin_offset)

func update_camera(direction : Vector2) -> void:
	current_room += direction
	set_position(current_room * Vector2(camera_horizontal_movement, camera_vertical_movement))

func _on_left_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_position(Vector2(position.x - 1000, position.y))


func _on_right_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_position(Vector2(position.x + 1000, position.y))
