extends Player
# Script for the player recorder

##### SIGNALS #####
signal record_done

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _record_resource : RecordResource
var _current_frame_time := 0.0
var _current_frame_idx := 0
var _replaying := false

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process_func(delta):
    if _replaying:
        _current_frame_time += delta
        var _closest_frame = _find_closest_frame()
        if _current_frame_idx == _record_resource.FRAME_DATA.size():
            _stop_replay()
        ._process_func(delta)
        

##### PUBLIC METHODS #####
func start_replay(record_resource : RecordResource):
    _record_resource = record_resource
    global_transform.origin = record_resource.PLAYER_START_POS
    _current_frame_time = 0.0
    _current_frame_idx = 0
    _replaying = true

##### PROTECTED METHODS #####
func _find_closest_frame() -> RecordFrameResource:
    while _current_frame_idx < _record_resource.FRAME_DATA.size() and _record_resource.FRAME_DATA[_current_frame_idx].FRAME_TIME < _current_frame_time:
        _current_frame_idx += 1
    return _record_resource.FRAME_DATA[_current_frame_idx]

func _stop_replay() -> void:
    _replaying = false

# Overriden from parent, does nothing
func _input_func(_event):
    pass

# Overriden from parent
func _process_input(_delta) -> void:
    var frame = _record_resource.FRAME_DATA[_current_frame_idx]

    # Mouse event, not exactly the same as using from _input, but that should be fine (i hope)
    ._set_camera_from_input_relative(frame.MOUSE)

    # Camera
    dir = Vector3()
    var cam_xform = camera.get_global_transform()

    # Standard movement
    input_movement_vector = Vector2()
    if GlobalConstants.INPUT_MVT_FORWARD in frame.INPUTS_PRESSED:
        input_movement_vector.y += 1
    if GlobalConstants.INPUT_MVT_BACKWARD in frame.INPUTS_PRESSED:
        input_movement_vector.y -= 1
    if GlobalConstants.INPUT_MVT_LEFT in frame.INPUTS_PRESSED:
        input_movement_vector.x -= 1
    if GlobalConstants.INPUT_MVT_RIGHT in frame.INPUTS_PRESSED:
        input_movement_vector.x += 1
    input_movement_vector = input_movement_vector.normalized()

    # Wished direction
    dir += -cam_xform.basis.z * input_movement_vector.y
    dir += cam_xform.basis.x * input_movement_vector.x

    # Shooting
    if (
        GlobalConstants.INPUT_ACTION_SHOOT in frame.INPUTS_PRESSED 
        and frame.INPUTS_PRESSED[GlobalConstants.INPUT_ACTION_SHOOT].just_pressed
        and not get_state_value(states_idx.SHOOTING)
        and ROCKETS_ENABLED
    ):
        _shoot(cam_xform)

    # Slide/Wall ride
    if (GlobalConstants.INPUT_MVT_SLIDE in frame.INPUTS_PRESSED
        and frame.INPUTS_PRESSED[GlobalConstants.INPUT_MVT_SLIDE].just_pressed
        and SLIDE_ENABLED):
        _slide = true
    elif (GlobalConstants.INPUT_MVT_SLIDE in frame.INPUTS_PRESSED
        and frame.INPUTS_PRESSED[GlobalConstants.INPUT_MVT_SLIDE].just_released):
        _slide = false
    if SLIDE_ENABLED: # slide also unlocks wall ride
        _wall_ride_strategy.process_input()
    
    # Other inputs, usefull later
    _current_inputs.forward_pressed = GlobalConstants.INPUT_MVT_FORWARD in frame.INPUTS_PRESSED
    _current_inputs.jump_pressed = GlobalConstants.INPUT_MVT_JUMP in frame.INPUTS_PRESSED
    _current_inputs.slide_pressed = GlobalConstants.INPUT_MVT_SLIDE in frame.INPUTS_PRESSED
