extends Area2D

var speed = 1050
@onready var sprite: Sprite2D = $pivot/Sprite2D
@onready var pivot: Node2D = $pivot

func _physics_process(delta):
	position += transform.x * speed * delta
	pivot.rotation += deg_to_rad(25)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		area.damage(1)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		queue_free()
