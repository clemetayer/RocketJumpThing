extends Node
# records the inputs pressed for a specific period of time

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const RECORDS_FOLDER := "res://Game/Records/"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var recording := false 

#==== PRIVATE ====
var _current_record_resource : RecordResource
var _current_mouse_motion := Vector2.ZERO

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
func _input(event):
	if recording and event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_current_mouse_motion = event.relative

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if recording: # record frame
		_record_frame(delta)

##### PUBLIC METHODS #####
func start_recording(record_resource : RecordResource) -> void:
	if GlobalParameters.INPUT_RECORDER_ENABLED:
		Logger.debug("start recording")
		_current_record_resource = record_resource
		_current_mouse_motion = Vector2.ZERO
		recording = true

func stop_recording() -> void:
	Logger.debug("stop recording")
	recording = false
	_save_frames()

##### PROTECTED METHODS #####
func _save_frames() -> void:
	DebugUtils.log_save_resource(_current_record_resource, RECORDS_FOLDER + Time.get_datetime_string_from_system() + ".tres")

func _record_frame(delta) -> void:
	_current_record_resource.TOTAL_TIME += delta
	var frame = RecordFrameResource.new()
	frame.FRAME_TIME = _current_record_resource.TOTAL_TIME
	frame.INPUTS_PRESSED = {}
	frame.MOUSE = _current_mouse_motion * SettingsUtils.settings_data.controls.mouse_sensitivity
	for input in InputMap.get_actions():
		# Logger.debug("recording %s" % input)
		if Input.is_action_pressed(input) or Input.is_action_just_released(input):
			frame.INPUTS_PRESSED[input] = {
				"just_pressed":Input.is_action_just_pressed(input),
				"just_released":Input.is_action_just_released(input)
			}
	_current_record_resource.FRAME_DATA.append(frame)
	# resets the mouse motion event
	_current_mouse_motion = Vector2.ZERO
