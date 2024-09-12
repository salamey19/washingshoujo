extends Node



@onready var root : Control = %Root
@onready var main: Control = %Main
@onready var credits: Control = $Root/Credits

## Preload settings scene.
var settings : PackedScene = preload("res://components/menu/settings.tscn")

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var check_box: CheckBox = $Root/Main/CheckBox

@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var select_sound: AudioStreamPlayer = $SelectSound

var start_normal_pos : float = -2
var settings_normal_pos : float = -4
var credits_normal_pos : float = -2
var quit_normal_pos : float = -2

func _ready() -> void:
	# Enable keyboard/controller navigation.

	%Start.grab_focus()
	check_box.button_pressed = Global.intro_done
	%Transition.play("fade_out")
	$TitleVoice.play()
	await $TitleVoice.finished
	$MenuMusic.play()
	Global.boss_checkpoint_met = false
	#color_rect.visible = false

func _on_start_pressed() -> void:
	select_sound.play()
	%Transition.play("fade_in")
	await %Transition.animation_finished
	Global.start_game()

## Open settings menu, the menu is preloaded and only instantiated.
func _on_settings_pressed() -> void:
	select_sound.play()
	main.hide()
	var settings_menu : Control = settings.instantiate()
	root.add_child(settings_menu)
	settings_menu.close_settings.connect(_on_settings_closed)

## Connected when the settings menu is opened, focuses a button to enable keyboard/controller navigation.
func _on_settings_closed() -> void:
	select_sound.play()
	main.show()
	%Start.grab_focus()

func _on_credits_pressed() -> void:
	select_sound.play()
	main.hide()
	credits.visible = true

## Quit the game.
func _on_quit_pressed() -> void:
	select_sound.play()
	await select_sound.finished
	get_tree().quit()


func _on_credits_close_pressed() -> void:
	credits.visible = false
	main.show()


func _on_check_box_toggled(toggled_on: bool) -> void:
	Global.intro_done = toggled_on
	print(Global.intro_done)


var start_change : float = 39
var setting_change : float = 23
var credit_change : float = 27
var quit_change : float = 43

func _on_start_mouse_entered() -> void:
	hover_sound.play()
	if %Start.get_child(0).position.x != start_normal_pos:
		%Start.get_child(0).position.x -= start_change





func _on_start_mouse_exited() -> void:
	if %Start.get_child(0).position.x != (start_normal_pos + start_change):
		%Start.get_child(0).position.x += start_change

func _on_start_button_down() -> void:
	if %Start.get_child(0).position.x != (start_normal_pos + start_change):
		%Start.get_child(0).position.x += start_change


func _on_start_button_up() -> void:
	if %Start.get_child(0).position.x != start_normal_pos:
		%Start.get_child(0).position.x -= start_change






func _on_settings_mouse_entered() -> void:
	hover_sound.play()
	if %Settings.get_child(0).position.x != settings_normal_pos:
		%Settings.get_child(0).position.x -= setting_change

func _on_settings_mouse_exited() -> void:
	if %Settings.get_child(0).position.x != (settings_normal_pos + setting_change):
		%Settings.get_child(0).position.x += setting_change

func _on_settings_button_down() -> void:
	if %Settings.get_child(0).position.x != (settings_normal_pos + setting_change):
		%Settings.get_child(0).position.x += setting_change

func _on_settings_button_up() -> void:
	if %Settings.get_child(0).position.x != settings_normal_pos:
		%Settings.get_child(0).position.x -= setting_change



func _on_credits_mouse_entered() -> void:
	hover_sound.play()
	if %Credits.get_child(0).position.x != credits_normal_pos:
		%Credits.get_child(0).position.x -= credit_change


func _on_credits_mouse_exited() -> void:
	if %Credits.get_child(0).position.x != (credits_normal_pos + credit_change):
		%Credits.get_child(0).position.x += credit_change


func _on_credits_button_down() -> void:
	if %Credits.get_child(0).position.x != (credits_normal_pos + credit_change):
		%Credits.get_child(0).position.x += credit_change


func _on_credits_button_up() -> void:
	if %Credits.get_child(0).position.x != credits_normal_pos:
		%Credits.get_child(0).position.x -= credit_change



func _on_quit_mouse_entered() -> void:
	hover_sound.play()
	if %Quit.get_child(0).position.x != quit_normal_pos:
		%Quit.get_child(0).position.x -= quit_change


func _on_quit_mouse_exited() -> void:
	if %Quit.get_child(0).position.x != (quit_normal_pos + quit_change):
		%Quit.get_child(0).position.x += quit_change


func _on_quit_button_down() -> void:
	if %Quit.get_child(0).position.x != (quit_normal_pos + quit_change):
		%Quit.get_child(0).position.x += quit_change


func _on_quit_button_up() -> void:

	if %Quit.get_child(0).position.x != quit_normal_pos:
		%Quit.get_child(0).position.x -= quit_change
