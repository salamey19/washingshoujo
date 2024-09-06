extends Area2D


var speed = 1150

func _physics_process(delta):
	#position += transform.x * speed * delta
	position += transform.y * speed * delta
	#rotation += deg_to_rad(25)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damaged()
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
