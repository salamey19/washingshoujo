extends AudioStreamPlayer



## Signal to respond to beats, includes index.
signal beat(index)

## Path to music folder.
const MUSIC_FOLDER_PATH : String = "res://art/music/"

## Beats per minute of the current music.
var bpm : float
## The index of the last beat that happened.
var last_passed_beat : int = 0

var _time_begin : int
var _time_delay : float



func _ready() -> void:
	bus = &"Music"



## Get and play song by title, optional format parameter.
func play_song(title : String, format : String = "mp3") -> void:
	var music_path : String = "{0}{1}.{3}".format([MUSIC_FOLDER_PATH, title, format])
	if !ResourceLoader.exists(music_path): return
	stream = ResourceLoader.load(music_path)
	begin_playback()

func begin_playback() -> void:
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		if stream.get_bpm() > 0: bpm = stream.get_bpm()
		else:
			printerr("No BPM Defined!")
			return
	elif stream is AudioStreamWAV:
		printerr("WAVE files not supported!")

	Engine.set_physics_ticks_per_second( ceil(bpm) )

	_time_begin = Time.get_ticks_usec()
	_time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	last_passed_beat = 0

	play()

## Reset player and associated values.
func reset() -> void:
	bpm = 0
	last_passed_beat = 0
	Engine.set_physics_ticks_per_second( 60 )

	stop()

func _physics_process(_delta: float) -> void:
	if !playing: return
	var current_beat : int = get_current_beat()
	if current_beat > last_passed_beat:
		last_passed_beat = current_beat
		beat.emit(current_beat)

## Return current playback time as a float.
func _get_playback_time() -> float:
	# Obtain from ticks.
	var time = (Time.get_ticks_usec() - _time_begin) / 1000000.0
	# Compensate for latency.
	time -= _time_delay
	# May be below 0 (did not begin yet).
	time = max(0, time)
	return time

## Return current beat as int.
func get_current_beat() -> int:
	return int(_get_playback_time() / (60.0 / bpm))
