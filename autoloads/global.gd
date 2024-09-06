extends Node


signal enemy_defeated
signal player_hurt
signal boss_hurt
signal bonk
var intro_done : bool = false

## Whether or not the app is currently focused.
var is_app_focused : bool = true

const TEST_LEVEL = preload("res://levels/test_level.tscn")


#restart level on death? if has checkpoint respawn there
func restart_level() -> void:
	get_tree().change_scene_to_packed(TEST_LEVEL)

func start_game() -> void:

	get_tree().change_scene_to_packed(TEST_LEVEL)




## Convert events into user-readable text.
func event_to_text(event : InputEvent) -> String:
	var text : String = event.as_text()

	if event is InputEventKey:
		if text == "(Unset)": text = "None"

	elif event is InputEventJoypadButton:
		match event.button_index:
			JOY_BUTTON_DPAD_UP, JOY_BUTTON_DPAD_DOWN, JOY_BUTTON_DPAD_LEFT, JOY_BUTTON_DPAD_RIGHT:
				text = text.substr(text.find("(") + 1, text.find(")") - text.find("(") - 1)
			JOY_BUTTON_LEFT_STICK, JOY_BUTTON_RIGHT_STICK:
				text = text.substr(text.find("(") + 1, text.find(",") - text.find("(") - 1) + " Button"
			_:
				text = text.substr(text.find("(") + 1, text.find(",") - text.find("(") - 1)

	elif event is InputEventJoypadMotion:
		match event.axis:
			JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y:
				text = "Left Stick"
			JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y:
				text = "Right Stick"
			JOY_AXIS_TRIGGER_LEFT:
				text = "Left Trigger"
				return text
			JOY_AXIS_TRIGGER_RIGHT:
				text = "Right Trigger"
				return text

		if event.axis_value < 0:
			text = text + " Up" if event.axis % 2 else text + " Left"
		elif event.axis_value > 0:
			text = text + " Down" if event.axis % 2 else text + " Right"

	return text



## Catch all controller inputs while the app is unfocused.
func _input(event: InputEvent) -> void:
	if !is_app_focused:
		if event is InputEventJoypadButton or InputEventJoypadMotion: get_viewport().set_input_as_handled()

## Update app focus status.
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			is_app_focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			is_app_focused = true
