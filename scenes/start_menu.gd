extends Node



@onready var root : Control = %Root
@onready var main: Control = %Main
@onready var credits: Control = $Root/Credits

## Preload settings scene.
var settings : PackedScene = preload("res://components/menu/settings.tscn")



func _ready() -> void:
	# Enable keyboard/controller navigation.
	%Start.grab_focus()

func _on_start_pressed() -> void:
	Global.start_game()

## Open settings menu, the menu is preloaded and only instantiated.
func _on_settings_pressed() -> void:
	main.hide()
	var settings_menu : Control = settings.instantiate()
	root.add_child(settings_menu)
	settings_menu.close_settings.connect(_on_settings_closed)

## Connected when the settings menu is opened, focuses a button to enable keyboard/controller navigation.
func _on_settings_closed() -> void:
	main.show()
	%Start.grab_focus()

func _on_credits_pressed() -> void:
	main.hide()
	credits.visible = true

## Quit the game.
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_close_pressed() -> void:
	credits.visible = false
	main.show()
