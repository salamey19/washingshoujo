extends Control

var settings : PackedScene = preload("res://components/menu/settingspaused.tscn")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu") and !get_tree().paused:
		get_tree().paused = true
		var settings_menu : Control = settings.instantiate()
		add_child(settings_menu)
		settings_menu.close_settings.connect(_on_settings_closed)

func _on_settings_closed() -> void:
	get_tree().paused = false
