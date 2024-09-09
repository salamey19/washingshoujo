extends PanelContainer



@onready var _tab_buttons : VBoxContainer = %TabButtons
@onready var _tab_container : TabContainer = %TabContainer

## List of all tabs.
var tab_list : Dictionary
## List of all SettingContainers.
var setting_list : Dictionary
## Buttongroup for all tab buttons.
var tab_button_group : ButtonGroup = ButtonGroup.new()
## Target button for KeyInput rebind.
var _button_target : Button

signal close_settings


func _ready() -> void:
	fill_menu()

	# Enter focused state.
	focus_topmost_button()



func fill_menu() -> void:
	var structure = Config.config_structure
	var source = Config.settings

	## Add tabs based on config structure.
	for section in structure:
		add_tab(section)

	## Add settings to their respective tabs.
	for setting_name in source:
		var setting = source[setting_name]
		## Continue if no button type is given.
		if !setting.options.has("button_type"): continue
		add_setting(tab_list[setting.section], setting)

	## Remove empty tabs.
	for tab_name in tab_list.keys():
		if !tab_list[tab_name].get_child_count():
			tab_list[tab_name].get_parent().queue_free()
			tab_list.erase(tab_name)

			_tab_buttons.get_node(tab_name).queue_free()

	update_all()

	for container in setting_list.keys():
		if setting_list[container].setting.options.has("disable_conditions"):
			for condition in setting_list[container].setting.options["disable_conditions"]:
				source[ condition[0] ].value_changed.connect( func(): setting_list[container].update() )

	## Initial buttongroup pressed state.
	_tab_buttons.get_child(0).button_pressed = true



## Focus the topmost button of the currently active tab.
func focus_topmost_button() -> void:
	tab_list.values()[_tab_container.current_tab].get_child(0).get_child(1).grab_focus()



## Tab setup.
func add_tab(tab_name : String) -> VBoxContainer:
	## Create scrollable tab content.
	var scroll = ScrollContainer.new()
	scroll.name = tab_name.replace("_", " ").capitalize()
	scroll.follow_focus = true
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.theme_type_variation = "SettingScrollable"
	_tab_container.add_child(scroll)

	## Create container for the settings.
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)
	tab_list[tab_name] = vbox

	## Create button in tab list.
	var tab_button = Button.new()
	tab_button.toggle_mode = true
	tab_button.text = scroll.name
	tab_button.name = tab_name
	tab_button.focus_mode = Control.FOCUS_NONE
	tab_button.button_group = tab_button_group
	tab_button.theme_type_variation = "TabButton"
	_tab_buttons.add_child(tab_button)
	tab_button.pressed.connect( func():
		select_tab(tab_button.get_index())
	)
	return vbox

func add_setting(parent : VBoxContainer, setting : ConfigSetting) -> SettingContainer:
	var container = SettingContainer.new(setting)

	parent.add_child(container)
	parent.add_child(HSeparator.new())

	add_buttons(container, setting)

	setting_list[setting.name] = container
	return container

func add_buttons(container : SettingContainer, setting : ConfigSetting)-> void:
	var buttons : Array = []
	match setting.options["button_type"]:
		1: # OptionButton
			var button = OptionButton.new()
			button.alignment = HORIZONTAL_ALIGNMENT_RIGHT

			var counter : int = 0
			for selector in setting.options["selectors"]:
				button.add_item(selector[1], counter)
				counter += 1

			button.item_selected.connect( func(idx): setting.set_value( setting.options["selectors"][button.get_item_id(idx)][0] ) )

			container.set_visual = func(value):
				for idx in button.item_count:
					if value == setting.options["selectors"][idx][0]:
						button.selected = idx
			buttons.append(button)
		2: # Number-Based Input
			var spinbox = SpinBox.new()

			if setting.options.has("min"): spinbox.min_value = setting.options["min"]
			else: spinbox.allow_lesser = true
			if setting.options.has("max"): spinbox.max_value = setting.options["max"]
			else: spinbox.allow_greater = true

			spinbox.value_changed.connect( func(val): setting.set_value(val) )

			container.set_visual = func(value):
				spinbox.set_value_no_signal(value)

			buttons.append(spinbox)
		3: # Slider
			var slider = HSlider.new()
			slider.custom_minimum_size = Vector2(150, 0)
			slider.step = setting.options["step"] if setting.options.has("step") else 0.01
			slider.min_value = setting.options["min"] if setting.options.has("min") else 0
			slider.max_value = setting.options["max"] if setting.options.has("max") else 1

			var slider_label = Label.new()
			slider_label.custom_minimum_size = Vector2(35, 0)

			slider.value_changed.connect( func(val):
				setting.set_value(val)
				slider_label.text = str(val)
			)

			container.set_visual = func(value):
				slider.value = value
				slider_label.text = str(value)

			buttons.append(slider)
			buttons.append(slider_label)
		4: # Toggle
			var check_button = CheckButton.new()

			check_button.toggled.connect( func(val): setting.set_value(val) )

			container.set_visual = func(value):
				check_button.button_pressed = value

			buttons.append(check_button)
		10: # KeyRebindButton
			var counter : int = 0
			for keybind in setting.value:
				var button = Button.new()
				button.name = str(counter)

				button.pressed.connect(_listen_for_input.bind(button))
				buttons.append(button)
				counter += 1
			container.set_visual = func(value):
				for idx in buttons.size():
					var evt = InputEventKey.new()
					evt.keycode = value[idx]
					buttons[idx].text = Global.event_to_text(evt)
		11: # JoyRebindButton
			var button = Button.new()

			button.pressed.connect(_listen_for_input.bind(button))

			container.set_visual = func(value):
				if value[1] == "btn":
					var event = InputEventJoypadButton.new()
					event.button_index = value[0]
					button.text = Global.event_to_text(event)
				else:
					var event = InputEventJoypadMotion.new()
					if value[0] != -1:
						event.axis = value[0]
						event.axis_value = value[2]
						button.text = Global.event_to_text(event)
					else: button.text = "None"

			buttons.append(button)
		_: # Other
			var button = Button.new()
			button.text = str(setting.value)

			buttons.append(button)

	for btn in buttons:
		container.add_child(btn)
		if !btn.custom_minimum_size: btn.custom_minimum_size = Vector2(75, 0)
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER



func _input(event: InputEvent) -> void:
	if !_button_target:
		if event.is_action_pressed(&"menu"):
			get_viewport().set_input_as_handled()
			_on_close_pressed()
		elif event.is_action_pressed(&"ui_focus_prev") && get_viewport().gui_get_focus_owner():
			if !self.is_ancestor_of(get_viewport().gui_get_focus_owner()): return
			get_viewport().set_input_as_handled()
			select_tab( wrapi(_tab_container.current_tab - 1, 0, _tab_container.get_tab_count()) )
		elif event.is_action_pressed(&"ui_focus_next") && get_viewport().gui_get_focus_owner():
			if !self.is_ancestor_of(get_viewport().gui_get_focus_owner()): return
			get_viewport().set_input_as_handled()
			select_tab( wrapi(_tab_container.current_tab + 1, 0, _tab_container.get_tab_count()) )
		elif event is InputEventJoypadButton && !get_viewport().gui_get_focus_owner():
			focus_topmost_button()
		return

	if !event is InputEventMouseButton && !event is InputEventKey && !event is InputEventJoypadButton && !event is InputEventJoypadMotion: return
	get_viewport().set_input_as_handled()

	var target_setting : String = _button_target.get_parent().name

	if ( event is InputEventKey || event is InputEventMouseButton ) && target_setting.begins_with("kbd"):
		var target_value : Array[Key]

		# Set keybind to none on click or escape press.
		if event is InputEventMouseButton:
			event = InputEventKey.new()
			event.keycode = KEY_NONE
		elif event.keycode == KEY_ESCAPE:
			event = InputEventKey.new()
			event.keycode = KEY_NONE

		# Target the first or second position in the array based on the button_target.
		if _button_target.name == "0":
			target_value = [ event.keycode, Config.settings[target_setting].value[1] ]
		else:
			target_value = [ Config.settings[target_setting].value[0], event.keycode ]

		Config.settings[target_setting].set_value( target_value )

	elif event is InputEventJoypadButton && target_setting.begins_with("ctrlr"):
		Config.settings[target_setting].set_value( [event.button_index, "btn"] )

	elif event is InputEventJoypadMotion && target_setting.begins_with("ctrlr"):
		if event.axis_value < 0: event.axis_value = -1
		else: event.axis_value = 1
		Config.settings[target_setting].set_value( [event.axis, "axis", event.axis_value] )
	else:
		# Ignore if none matched.
		return

	_button_target.text = Global.event_to_text(event)
	_button_target = null
	return



## Select tab via click.
func select_tab(index : int) -> void:
	_tab_container.current_tab = index
	_tab_buttons.get_child(index).button_pressed = true
	focus_topmost_button()

## Update all settings.
func update_all() -> void:
	for container in setting_list.keys():
		setting_list[container].update()

func _listen_for_input(button : Button) -> void:
	_button_target = button
	button.text = "Set"

func _on_reset_pressed() -> void:
	## TODO: Confirm window here.
	reset_all()

func reset_all() -> void:
	for container in setting_list.keys():
		setting_list[container].setting.reset()
	update_all()

func _on_close_pressed() -> void:
	close_settings.emit()
	get_tree().paused = false
	queue_free()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	Global.main_menu()
