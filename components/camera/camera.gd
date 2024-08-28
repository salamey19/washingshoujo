extends Camera2D



var camera_shake_noise : FastNoiseLite


func _ready() -> void:
	camera_shake_noise = FastNoiseLite.new()


func camera_shake(intensity : float = 5.0) -> void:
	var tween = create_tween()
	tween.tween_method(startCameraShake, intensity, 1.0, 0.5)

func startCameraShake(intensity : float):
	var cameraOffset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	offset.x = cameraOffset
	offset.y = cameraOffset
