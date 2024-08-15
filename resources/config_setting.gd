extends RefCounted

## A setting used in the user config.
class_name ConfigSetting



var section : String
var name : String
var desc : String

var _default_value : Variant
var value : Variant :
	set(val):
		value = val
		value_changed.emit()
var options : Dictionary

signal value_changed


func _init(identifier : String, default = null) -> void:
	name = identifier
	_default_value = default
	value = default



func set_value(new_value : Variant) -> ConfigSetting:
	value = new_value
	Config.apply(self)
	return self

func set_description(string : String) -> ConfigSetting:
	desc = string
	return self

func set_options(dict : Dictionary) -> ConfigSetting:
	options = dict
	return self



func reset() -> void:
	value = _default_value
	Config.apply(self)
