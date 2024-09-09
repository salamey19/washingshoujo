extends Node

## The path to the config file.
const CONFIG_PATH : String = "user://config.cfg"

## The structure of the config file and it's default values, used to sort values and generate menus.
var config_structure : Dictionary = {
	"video": [
		ConfigSetting.new("vsync", ProjectSettings.get("display/window/vsync/vsync_mode"))\
			.set_options({"button_type": 1, "selectors": [ [0, "Disabled"], [1, "Enabled"], [2, "Adaptive"] ]}),
		ConfigSetting.new("max_fps", ProjectSettings.get("application/run/max_fps"))\
			.set_options({"button_type": 2, "min": 0, "disable_conditions": [ ["vsync", 1], ["vsync", 2] ]})
	],
	"audio": [
		ConfigSetting.new("master", 75)\
			.set_options({"button_type": 3, "max": 100, "step": 1}),
		ConfigSetting.new("music", 75)\
			.set_options({"button_type": 3, "max": 100, "step": 1}),
		ConfigSetting.new("effects", 75)\
			.set_options({"button_type": 3, "max": 100, "step": 1}),
		ConfigSetting.new("voice", 75)\
			.set_options({"button_type": 3, "max": 100, "step": 1})
	],
	"keyboard": [
		ConfigSetting.new("kbd_move_left", [KEY_A, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Move Left"}),
		ConfigSetting.new("kbd_move_right", [KEY_D, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Move Right"}),
		ConfigSetting.new("kbd_move_down", [KEY_S, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Move Down"}),
		ConfigSetting.new("kbd_jump", [KEY_SPACE, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Jump"}),
		ConfigSetting.new("kbd_dash", [KEY_SHIFT, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Dash"}),
		ConfigSetting.new("kbd_attack", [KEY_E, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Attack"}),
		ConfigSetting.new("kbd_ability1", [KEY_F, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Ability 1"}),
		ConfigSetting.new("kbd_ability2", [KEY_G, KEY_NONE])\
			.set_options({"button_type": 10, "display_text": "Ability 2"})
	]
}

## The actual active settings dictionary.
var settings : Dictionary



func _ready() -> void:
	load_file()



## Save the current file to the user folder.
func save_file() -> Error:
	var config_file = ConfigFile.new()

	for setting_name in settings:
		var setting = settings[setting_name]
		config_file.set_value(setting.section, setting.name, setting.value)

	return config_file.save(CONFIG_PATH)

## Load and apply settings. If no file exists, create one.
func load_file() -> void:
	var config_file = ConfigFile.new()

	var error = config_file.load(CONFIG_PATH)
	if error: print("No config file found, a new config file is being generated.")

	for section in config_structure:
		for setting in config_structure[section]:
			if !setting is String:
				setting.section = section
				settings[setting.name] = setting
				if !error && config_file.has_section_key(section, setting.name): setting.set_value(config_file.get_value(section, setting.name))
				else: apply(setting)

	if error: if save_file(): print("Could not save config file.")

## Resets the local dictionary to it's original state.
func reset_file() -> void:
	settings = {}
	for section in config_structure:
		for setting in config_structure[section]:
			if !setting is String:
				setting.reset()
				setting.section = section
				settings[setting.name] = setting
	save_file()



## Apply a setting and have it's value take effect, optionally save the config file as well.
func apply(setting : ConfigSetting, do_save : bool = true) -> void:
	if do_save: save_file()

	match setting.section:
		"audio":
			var bus_target : int = AudioServer.get_bus_index(setting.name.capitalize())
			if bus_target == -1: return

			var value_convert : float = remap(setting.value, 0, 100, -60, 0)

			AudioServer.set_bus_volume_db(bus_target, value_convert)
			AudioServer.set_bus_mute(bus_target, setting.value == 0)
			return

	match setting.name:
		"vsync":
			DisplayServer.window_set_vsync_mode(setting.value)
		"max_fps":
			Engine.set_max_fps(setting.value)

	# Below here is the applying if inputs.
	if !setting.options.has("button_type"): return
	if !( setting.options["button_type"] == 10 || setting.options["button_type"] == 11 ): return

	var target_action : String = setting.name.right(setting.name.length() - setting.name.find("_") - 1)

	var events : Array[InputEvent] = InputMap.action_get_events(target_action)

	if setting.options["button_type"] == 10:
		for event in events:
			if event is InputEventKey: InputMap.action_erase_event(target_action, event)
		for keybind in setting.value:
			var event = InputEventKey.new()
			event.keycode = keybind
			InputMap.action_add_event(target_action, event)

	if setting.options["button_type"] == 11:
		for event in events:
			if event is InputEventJoypadButton || event is InputEventJoypadMotion: InputMap.action_erase_event(target_action, event)
		if setting.value[1] == "btn":
			var event = InputEventJoypadButton.new()
			event.button_index = setting.value[0]
			InputMap.action_add_event(target_action, event)
		else:
			if setting.value[0] == -1: return
			var event = InputEventJoypadMotion.new()
			event.axis = setting.value[0]
			event.axis_value = setting.value[2]
			InputMap.action_add_event(target_action, event)
