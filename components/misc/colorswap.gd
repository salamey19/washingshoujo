extends Panel


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_hurt.connect(hurt)

func hurt() -> void:
	#animation_player.play("hurt")
	visible = true
	await get_tree().create_timer(0.3).timeout
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
