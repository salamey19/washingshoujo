extends Area2D

@export var change_pos : bool = false
@export var camera_pos : Vector2

@export var change_zoom : bool = false
@export var camera_zoom = Vector2()

@export var change_limits : bool = false
@export var right_limit : int
@export var left_limit : int
@export var top_limit : int
@export var bottom_limit : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var camera : Camera2D
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("change camera")
		if change_pos:
			camera.position = camera_pos
		if change_zoom:
			get_tree().get_first_node_in_group("Camera").change_zoom(camera_zoom)
		if change_limits:
			get_tree().get_first_node_in_group("Camera").change_limits(left_limit, right_limit, top_limit, bottom_limit)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass
