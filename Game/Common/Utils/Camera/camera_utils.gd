extends Node
# An utility tool for camera effects

##### VARIABLES #####
#---- CONSTANTS -----
const SHAKE_TRANS := Tween.TRANS_SINE
const SHAKE_EASE := Tween.EASE_IN
const AMP_TRANS := Tween.TRANS_SINE
const AMP_EASE := Tween.EASE_IN

#==== PRIVATE ====
var _amplitude = 0
var _priority = 0
var _camera: Camera
var _duration_timer: Timer
var _frequency_timer: Timer
var _shake_tween: Tween
var _amplitude_tween: Tween
var _original_offset: Vector2


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_duration_timer = Timer.new()
	_frequency_timer = Timer.new()
	_shake_tween = Tween.new()
	_amplitude_tween = Tween.new()
	add_child(_duration_timer)
	add_child(_frequency_timer)
	add_child(_shake_tween)
	add_child(_amplitude_tween)
	DebugUtils.log_connect(_duration_timer, self, "timeout", "_on_duration_timer_timeout")
	DebugUtils.log_connect(_frequency_timer, self, "timeout", "_on_frequency_timer_timeout")


##### PUBLIC METHODS #####
# starts the camera shake
# very inspired from https://www.codingkaiju.com/tutorials/screen-shake-in-godot-the-best-way/
func start_camera_shake(
	duration = 1.0, frequency = 15, amplitude = 1.0, priority = 0, amplitude_divider = 2.0
) -> void:
	_camera = get_viewport().get_camera()
	_original_offset = Vector2(_camera.h_offset, _camera.v_offset)
	if priority >= _priority:
		_priority = priority
		_amplitude = amplitude
		_duration_timer.wait_time = duration
		_frequency_timer.wait_time = 1.0 / frequency
		_amplitude_tween.interpolate_property(
			self,
			"_amplitude",
			amplitude,
			amplitude / amplitude_divider,
			duration,
			AMP_TRANS,
			AMP_EASE
		)
		_duration_timer.start()
		_frequency_timer.start()
		_amplitude_tween.start()
		_new_shake()


##### PROTECTED METHODS #####
# creates one camera shake
func _new_shake() -> void:
	var shake_pos = Vector2(
		rand_range(-_amplitude / 100.0, _amplitude / 100.0),
		rand_range(-_amplitude / 100.0, _amplitude / 100.0)
	)
	shake_pos *= OS.window_size
	_shake_tween.interpolate_property(
		_camera,
		"h_offset",
		_camera.h_offset,
		shake_pos.x,
		_frequency_timer.wait_time,
		SHAKE_TRANS,
		SHAKE_EASE
	)
	_shake_tween.interpolate_property(
		_camera,
		"v_offset",
		_camera.v_offset,
		shake_pos.y,
		_frequency_timer.wait_time,
		SHAKE_TRANS,
		SHAKE_EASE
	)
	_shake_tween.start()


##### SIGNAL MANAGEMENT #####
func _on_duration_timer_timeout() -> void:
	_duration_timer.stop()
	_frequency_timer.stop()
	# tween to reset to the original offset
	_shake_tween.interpolate_property(
		_camera,
		"h_offset",
		_camera.h_offset,
		_original_offset.x,
		_frequency_timer.wait_time,
		SHAKE_TRANS,
		SHAKE_EASE
	)
	_shake_tween.interpolate_property(
		_camera,
		"v_offset",
		_camera.v_offset,
		_original_offset.y,
		_frequency_timer.wait_time,
		SHAKE_TRANS,
		SHAKE_EASE
	)
	_shake_tween.start()


func _on_frequency_timer_timeout() -> void:
	_new_shake()
	_frequency_timer.start()
