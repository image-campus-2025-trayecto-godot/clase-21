class_name Shaker
extends Node

var shake_time_left: float = 0.0
@export var intensity: float = 30
var current_intensity: float = 0.0
var intensity_tween: Tween
@export var max_intensity: float = 100.0
@export var noise: FastNoiseLite
var time_since_ready: float = 0.0
@export var frequency: float = 10.0 
var _shake_value: Vector2

func shake(duration: float, shake_intensity: float = intensity):
	shake_time_left = duration
	current_intensity += shake_intensity
	current_intensity = min(current_intensity, max_intensity)
	if intensity_tween and intensity_tween.is_valid():
		intensity_tween.kill()
	intensity_tween = create_tween()
	intensity_tween.tween_property(self, "current_intensity", 0.0, duration)

func shake_value() -> Vector2:
	return _shake_value

func _process(delta: float) -> void:
	time_since_ready += delta
	var noise_value_x = noise.get_noise_1d(time_since_ready * frequency)
	var noise_value_y = noise.get_noise_1d(time_since_ready * frequency + 50.0)
	shake_time_left = move_toward(
		shake_time_left,
		0.0,
		delta
	)
	if shake_time_left > 0.0:
		_shake_value = Vector2(
			current_intensity * noise_value_x,
			current_intensity * noise_value_y
		)
	else:
		_shake_value = Vector2.ZERO
