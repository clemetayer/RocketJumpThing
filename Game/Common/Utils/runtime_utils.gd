extends Node
# kind of like function_utils.gd but for everything that cannot be static
# TODO : Actually translate all the mouse inputs

##### VARIABLES #####
#---- CONSTANTS -----
const DEFAULT_LEVELS_DATA_PATH := "res://Game/Scenes/levels_data.tres"

#---- STANDARD -----
#==== PRIVATE ====
var levels_data: LevelsData = null


#### Display #####
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_default_levels_data()
	_load_levels_data()


# returns a string to display a pretty version of the input
func display_input_as_string(input: InputEvent) -> String:
	if input is InputEventKey:
		return input.as_text()
	elif input is InputEventMouseButton:
		match input.button_index:
			BUTTON_LEFT:
				return _translate_mouse_button(GlobalConstants.MOUSE_LEFT)
			BUTTON_RIGHT:
				return _translate_mouse_button(GlobalConstants.MOUSE_RIGHT)
			BUTTON_MIDDLE:
				return _translate_mouse_button(GlobalConstants.MOUSE_MIDDLE)
			BUTTON_XBUTTON1:
				return _translate_mouse_button(GlobalConstants.MOUSE_SPECIAL_1)
			BUTTON_XBUTTON2:
				return _translate_mouse_button(GlobalConstants.MOUSE_SPECIAL_2)
			BUTTON_WHEEL_UP:
				return _translate_mouse_button(GlobalConstants.MOUSE_WHEEL_UP)
			BUTTON_WHEEL_DOWN:
				return _translate_mouse_button(GlobalConstants.MOUSE_WHEEL_DOWN)
			BUTTON_WHEEL_LEFT:
				return _translate_mouse_button(GlobalConstants.MOUSE_WHEEL_LEFT)
			BUTTON_WHEEL_RIGHT:
				return _translate_mouse_button(GlobalConstants.MOUSE_WHEEL_RIGHT)
			BUTTON_MASK_LEFT:
				return _translate_mouse_button(GlobalConstants.MOUSE_MASK_LEFT)
			BUTTON_MASK_RIGHT:
				return _translate_mouse_button(GlobalConstants.MOUSE_MASK_RIGHT)
			BUTTON_MASK_MIDDLE:
				return _translate_mouse_button(GlobalConstants.MOUSE_MASK_MIDDLE)
			BUTTON_MASK_XBUTTON1:
				return _translate_mouse_button(GlobalConstants.MOUSE_MASK_SPECIAL_1)
			BUTTON_MASK_XBUTTON2:
				return _translate_mouse_button(GlobalConstants.MOUSE_MASK_SPECIAL_2)
	elif input is InputEventJoypadButton:
		return Input.get_joy_button_string(input.button_index)
	return ""  # TODO : put a better string for unrecognized inputs ?


func save_level_times(time: float) -> void:
	var level_data = levels_data.get_level(ScenesManager.get_current_level_idx())
	if level_data != null:
		if time < level_data.BEST_TIME:  # if best time, set best time
			level_data.BEST_TIME = time
		level_data.LAST_TIME = time
		levels_data.save()
	DebugUtils.log_stacktrace("Level data is null", DebugUtils.LOG_LEVEL.error)


#returns the total time (in unix timestamp millis) of the level in the current LevelsData
func get_levels_total_time() -> int:
	var time_sum = 0
	for level in levels_data.get_levels():
		time_sum += level.LAST_TIME
	return time_sum


func _translate_mouse_button(key_str: String) -> String:
	return (
		TranslationKeys.MOUSE_BUTTON_MAPPER[key_str]
		if TranslationKeys.MOUSE_BUTTON_MAPPER.has(key_str)
		else key_str
	)


func _create_default_levels_data() -> void:
	if not ResourceLoader.exists(LevelsData.SAVE_PATH):
		var res = load(DEFAULT_LEVELS_DATA_PATH)
		if res != null and res is LevelsData:
			res.save()


func _load_levels_data() -> void:
	levels_data = DebugUtils.log_load_resource(LevelsData.SAVE_PATH)
