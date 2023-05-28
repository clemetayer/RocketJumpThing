extends Node
class_name VariableShaker
# An utility tool to "shake" a variable
# By default frees itself when over

##### SIGNALS #####
signal shake_over

##### VARIABLES #####
#---- CONSTANTS -----
const SHAKE_TRANS := Tween.TRANS_SINE
const SHAKE_EASE := Tween.EASE_IN
const AMP_TRANS := Tween.TRANS_SINE
const AMP_EASE := Tween.EASE_IN

#---- STANDARD -----
#==== PRIVATE ====
var _variable: ShakeVariable  # the variable to be shaken
var _amplitude := 0.0
var _frequency := 15.0
var _duration := 1.0
var _free_when_over := true
var _duration_timer: Timer
var _frequency_timer: Timer
var _shake_tween: Tween
var _amplitude_tween: Tween


##### PROCESSING #####
# Called when the object is initialized.
func _init(
	variable: ShakeVariable = null,
	amplitude = 0,
	duration = 1.0,
	frequency = 15,
	free_when_over = true
):
	_variable = variable
	_amplitude = amplitude
	_duration = duration
	_frequency = frequency
	_free_when_over = free_when_over


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
# resets the variable to the original values by force and stops the shake
# (then frees itself if _free_when_over is true)
func stop_shake() -> void:
	if _ShakeVariable_valid(_variable):
		if _amplitude_tween.is_active():
			# stops the current shake to reset the camera
			DebugUtils.log_tween_stop_all(_amplitude_tween)
			DebugUtils.log_tween_stop_all(_shake_tween)
			_variable.object.set(_variable.property, _variable.original_value)
	if _free_when_over:
		queue_free()


# starts the shake
# very inspired from https://www.codingkaiju.com/tutorials/screen-shake-in-godot-the-best-way/
func start_shake() -> void:
	# resets the variable (in case the variable is currently shaking)
	if _ShakeVariable_valid(_variable):
		# maybe useless considering there is one var_shaker per property
		if _amplitude_tween.is_active():
			# stops the current shake to reset the camera
			DebugUtils.log_tween_stop_all(_amplitude_tween)
			DebugUtils.log_tween_stop_all(_shake_tween)
			_variable.object.set(_variable.property, _variable.original_value)
		_duration_timer.wait_time = _duration
		_frequency_timer.wait_time = 1.0 / _frequency
		DebugUtils.log_tween_interpolate_property(
			_amplitude_tween,
			self,
			"_amplitude",
			_amplitude,
			_amplitude,
			_duration,
			AMP_TRANS,
			AMP_EASE
		)
		_duration_timer.start()
		_frequency_timer.start()
		DebugUtils.log_tween_start(_amplitude_tween)
		_new_shake()


##### PROTECTED METHODS #####
# creates one camera shake
func _new_shake() -> void:
	var property_rand = rand_range(-_amplitude / 100.0, _amplitude / 100.0)
	DebugUtils.log_tween_interpolate_property(
		_shake_tween,
		_variable.object,
		_variable.property,
		_variable.original_value,
		property_rand,
		_frequency_timer.wait_time,
		SHAKE_TRANS,
		SHAKE_EASE
	)
	DebugUtils.log_tween_start(_shake_tween)


func _ShakeVariable_valid(variable) -> bool:
	return variable != null and variable is ShakeVariable and variable.is_valid()


##### SIGNAL MANAGEMENT #####
func _on_duration_timer_timeout() -> void:
	_duration_timer.stop()
	_frequency_timer.stop()
	# tween to reset to the original offset
	DebugUtils.log_tween_interpolate_property(
		_shake_tween,
		_variable.object,
		_variable.property,
		_variable.object.get(_variable.property),
		_variable.original_value,
		_frequency_timer.wait_time,
		SHAKE_TRANS,
		SHAKE_EASE
	)
	DebugUtils.log_tween_start(_shake_tween)
	yield(_shake_tween, "tween_all_completed")
	emit_signal("shake_over")
	if _free_when_over:
		queue_free()


func _on_frequency_timer_timeout() -> void:
	_new_shake()
	_frequency_timer.start()
