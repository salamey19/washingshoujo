extends AudioStreamPlayer



## Signal to respond to beats, includes index, emitted every beat.
signal beat(index : int)

## Path to music folder.
const MUSIC_FOLDER_PATH : String = "res://art/music/"

## Beats per minute of the current music.
var bpm : float :
	set(value):
		bpm = value
		beat_time = 60 / bpm if bpm else 0.0
## The index of the last beat that happened.
var last_passed_beat : int = 0
## The time a beat lasts, 60/bpm.
var beat_time : float

var _time_begin : int
var _time_delay : float



## General setup.
func _ready() -> void:
	bus = &"Music"



## Function still not completed, this will take a bit, I am still unsure on the exact execution and it's frying my brain.
## Gets the time offset to the specified beat as a float, negative numbers indicate early calls.
func get_beat_offset(beat_index : int) -> float:
	var elapsed_time_by_beat : float = beat_index * beat_time
	return _get_playback_time() - elapsed_time_by_beat



## Get and play song by title, optional format parameter.
func play_song(title : String, format : String = "mp3") -> void:
	var music_path : String = "{0}{1}.{2}".format([MUSIC_FOLDER_PATH, title, format])
	if !ResourceLoader.exists(music_path): return
	stream = ResourceLoader.load(music_path)
	begin_playback()

func begin_playback() -> void:
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		if stream.get_bpm() > 0: bpm = stream.get_bpm()
		else:
			printerr("No BPM Defined!")
			return
	else:
		printerr("Filetype not supported!")
		return

	_time_begin = Time.get_ticks_usec()
	_time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	last_passed_beat = 0

	play()

## Reset player and associated values.
func reset() -> void:
	bpm = 0
	last_passed_beat = 0

	stop()

func _physics_process(_delta: float) -> void:
	if !playing: return
	var current_beat : int = get_current_beat()
	# Avoid overlap by checking beat index.
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
