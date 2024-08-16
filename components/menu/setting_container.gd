extends HBoxContainer

class_name SettingContainer



var setting : ConfigSetting
var disabled : bool = false
var labels : Array
var set_visual : Callable


func _init(setup : ConfigSetting) -> void:
	setting = setup
	name = setting.name



func _ready() -> void:
	var label = Label.new()
	label.text = setting.options["display_text"] if setting.options.has("display_text") else setting.name.replace("_", " ").capitalize()

	label.custom_minimum_size = Vector2(250, 35)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	if setting.desc:
		label.tooltip_text = setting.desc
		label.mouse_filter = Control.MOUSE_FILTER_PASS

	add_child(label)



func update() -> void:
	if set_visual.is_valid(): set_visual.call(setting.value)

	if !setting.options.has("disable_conditions"): return

	var result : bool = false
	for check in setting.options["disable_conditions"]:
		if Config.settings[ check[0] ].value == check[1]:
			result = true
			toggle_disabled(true)
	if !result:
		toggle_disabled(false)



func toggle_disabled(value : bool) -> void:
	disabled = value
	if disabled:
		setting.reset()
	for child in get_children():
		if child is BaseButton:
			child.disabled = disabled
		if child is Range:
			child.editable = !disabled
