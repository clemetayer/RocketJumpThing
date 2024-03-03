extends Node
# kind of like function_utils.gd but for everything that cannot be static

##### VARIABLES #####
#---- CONSTANTS -----
const DEFAULT_LEVELS_DATA_PATH := "res://Game/Scenes/levels_data.tres"
const DEATH_SOUND_PATH := "res://Misc/Audio/FX/DeathSound/death.wav"
const BUTTON_CLICKED_SOUND := "res://Misc/Audio/FX/Menus/button_pressed.wav"
const BUTTON_CLICKED_VOLUME := 15.0
const BUTTON_HOVERED_SOUND := "res://Misc/Audio/FX/Menus/button_hover.wav"
const BUTTON_HOVER_VOLUME := 15.0
const SLIDER_MOVED_SOUND := "res://Misc/Audio/FX/Menus/slider_moved.wav"
const SLIDER_MOVED_VOLUME := -2.0
# Rockets
const ROCKET_EXPLOSION_PATH := "res://Game/Common/MovementUtils/Rocket/rocket_explosion.tscn"
const ROCKET_TARGET_PATH := "res://Game/Common/MovementUtils/Rocket/rocket_target.tscn"
const ROCKET_TARGET_SCENE := preload(ROCKET_TARGET_PATH) # preloads the target and the explosion once to improve performances
const ROCKET_EXPLOSION_SCENE := preload(ROCKET_EXPLOSION_PATH)

#---- STANDARD -----
#==== PRIVATE ====
var levels_data: LevelsData = null
var paths := {"death_sound": "", "button_clicked": "", "button_hover": "", "slider_moved": ""}


#### Display #####
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.set_logger_level(Logger.LOG_LEVEL_WARN)
	_create_default_levels_data()
	_load_levels_data()
	_init_death_sound()
	_init_ui_sound()


func play_death_sound() -> void:
	paths.death_sound.play()


func play_button_clicked_sound() -> void:
	paths.button_clicked.play()


func play_button_hover_sound() -> void:
	paths.button_hover.play()


func play_slider_moved_sound() -> void:
	paths.slider_moved.play()


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
	return ""


func save_level_times(time: float) -> void:
	var level_data = levels_data.get_level(ScenesManager.get_current_level_idx())
	if level_data != null:
		if time < level_data.BEST_TIME or level_data.BEST_TIME == 0.0:  # if best time, set best time
			level_data.BEST_TIME = time
		level_data.LAST_TIME = time
		save_levels_data()
	else:
		DebugUtils.log_stacktrace("Level data is null", DebugUtils.LOG_LEVEL.warn)


func save_levels_data() -> void:
	levels_data.save()


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


func _init_death_sound() -> void:
	paths.death_sound = AudioStreamPlayer.new()
	paths.death_sound.stream = load(DEATH_SOUND_PATH)
	paths.death_sound.bus = GlobalConstants.EFFECTS_BUS
	add_child(paths.death_sound)


# UI sounds are placed in runtime utils to save resources
func _init_ui_sound() -> void:
	_init_button_clicked_sound()
	_init_button_hover_sound()
	_init_slider_moved_sound()


func _init_button_clicked_sound() -> void:
	paths.button_clicked = AudioStreamPlayer.new()
	paths.button_clicked.stream = load(BUTTON_CLICKED_SOUND)
	paths.button_clicked.volume_db = BUTTON_CLICKED_VOLUME
	paths.button_clicked.bus = GlobalConstants.MAIN_BUS
	add_child(paths.button_clicked)


func _init_button_hover_sound() -> void:
	paths.button_hover = AudioStreamPlayer.new()
	paths.button_hover.stream = load(BUTTON_HOVERED_SOUND)
	paths.button_hover.volume_db = BUTTON_HOVER_VOLUME
	paths.button_hover.bus = GlobalConstants.MAIN_BUS
	add_child(paths.button_hover)


func _init_slider_moved_sound() -> void:
	paths.slider_moved = AudioStreamPlayer.new()
	paths.slider_moved.stream = load(SLIDER_MOVED_SOUND)
	paths.slider_moved.volume_db = SLIDER_MOVED_VOLUME
	paths.slider_moved.bus = GlobalConstants.MAIN_BUS
	add_child(paths.slider_moved)
