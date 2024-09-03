extends Area2D

@onready var hint_popup: CanvasLayer = $HintPopup

var hint_showed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if hint_showed:
		if Input.is_action_just_pressed("attack"):
			hint_popup.hide()
			get_tree().paused = false
			queue_free()


func popup() -> void:
	hint_popup.visible = true
	get_tree().paused = true

func intro_popup() -> void:
	hint_popup.visible = true
	hint_showed = true

func intro_close() -> void:
	hint_popup.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !hint_showed:
		hint_showed = true
		popup()
