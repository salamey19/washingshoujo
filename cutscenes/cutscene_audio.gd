extends Node2D

#THIS IS A PROGRAMMING CRIME DO NOT REPEAT
@onready var akira: Node = $Akira

var currently_playing : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CutsceneManager.play_audio.connect(_play_audio)

func _play_audio(character : int, line : int) -> void:
	stop_playing()
	if character == 0:
		akira_voice(line - 1)


func stop_playing() -> void:
	if currently_playing:
		currently_playing.stop()

func akira_voice(line : int) -> void:
	akira.get_child(line).play()
	currently_playing = akira.get_child(line)
