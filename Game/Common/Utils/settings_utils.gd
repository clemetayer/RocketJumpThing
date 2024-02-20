extends Node
# A bunch of methods to load or save settings

##### ENUMS #####
enum TUTORIAL_LEVEL { all, some, none }  # How much the game should explain things to the user

##### VARIABLES #####
#---- CONSTANTS -----
#==== GLOBAL =====
const CFG_FILE_EXTENSION := ".cfg"
const CURRENT_PRESET_FILE_NAME := "current"
const REGEX_PATTERN_CFG_FILE := "^(?!" + CURRENT_PRESET_FILE_NAME + ".cfg$).+\\.(?:cfg)$"
const REGEX_PATTERN_PNG_FILE := "(?:png)$"
const ROOT_PRESETS_FOLDER := "user://conf/"
const ROOT_SECTION_GENERAL := "general"
const ROOT_SECTION_CONTROLS := "controls"
const ROOT_SECTION_AUDIO := "audio"
const ROOT_SECTION_VIDEO := "video"
const ROOT_KEY_PRESET := "preset"
const FOLDER_SEPARATOR := "/"
const DEFAULT_INPUTS_FOLDER := "res://Misc/DefaultSettings/"

#==== GENERAL =====
const GENERAL_PRESETS_PATH := ROOT_PRESETS_FOLDER + "general/"
const GENERAL_SECTION_LANGUAGE := "language"
const GENERAL_SECTION_LANGUAGE_TEXT := "text"

#==== INPUTS =====
const INPUT_PRESETS_PATH := ROOT_PRESETS_FOLDER + "inputs/"
const KEY_CFG_PREFIX := "key_"
const MOUSE_BUTTON_CFG_PREFIX := "mouse_"
const JOYPAD_CFG_PREFIX := "joypad_"
const CONTROLS_SETTINGS_CFG_MAPPER := {
	"movement":
	{
		"forward": GlobalConstants.INPUT_MVT_FORWARD,
		"backward": GlobalConstants.INPUT_MVT_BACKWARD,
		"left": GlobalConstants.INPUT_MVT_LEFT,
		"right": GlobalConstants.INPUT_MVT_RIGHT,
		"jump": GlobalConstants.INPUT_MVT_JUMP,
		"slide": GlobalConstants.INPUT_MVT_SLIDE
	},
	"action": {"shoot": GlobalConstants.INPUT_ACTION_SHOOT},
	"ui":
	{
		"restart_last_cp": GlobalConstants.INPUT_RESTART_LAST_CP,
		"restart": GlobalConstants.INPUT_RESTART,
		"pause": GlobalConstants.INPUT_PAUSE
	}
}
const CONTROLS_SECTION_GENERAL := "general"
const CONTROLS_SECTION_GENERAL_SENSITIVITY := "mouse_sensitivity"
const CONTROLS_SECTION_GENERAL_CROSSHAIR_PATH := "crosshair_path"
const CONTROLS_SECTION_GENERAL_CROSSHAIR_COLOR := "crosshair_color"
const CONTROLS_SECTION_GENERAL_CROSSHAIR_SIZE := "crosshair_size"
const DEFAULT_CROSSHAIR := "res://Misc/UI/Crosshairs/PNG/WhiteRetina/crosshair013.png"

#==== AUDIO =====
const AUDIO_PRESETS_PATH := ROOT_PRESETS_FOLDER + "audio/"
const AUDIO_KEY_VOLUME := "volume"
const AUDIO_KEY_UNMUTED := "unmuted"
const AUDIO_SECTION_MAIN := "main"
const AUDIO_SECTION_BGM := "BGM"
const AUDIO_SECTION_EFFECTS := "effects"

#==== VIDEO =====
const VIDEO_PRESETS_PATH := ROOT_PRESETS_FOLDER + "video/"
const VIDEO_SECTION_MODE := "mode"
const VIDEO_KEY_MODE := "mode"
const VIDEO_SECTION_QUALITY := "quality"
const VIDEO_KEY_GLOW := "glow"
const VIDEO_KEY_REFLECTIONS := "reflections"

#==== GAMEPLAY =====
const GAMEPLAY_PRESETS_PATH := ROOT_PRESETS_FOLDER + "gameplay/"
const GAMEPLAY_SECTION_GAMEPLAY := "gameplay"
const GAMEPLAY_KEY_FOV := "fov"
const GAMEPLAY_KEY_SPACE_WALL_RIDE := "space_to_wall_ride"
const GAMEPLAY_SECTION_TUTORIAL := "tutorial"
const GAMEPLAY_KEY_LEVEL := "level"
const GAMEPLAY_SECTION_DIFFICULTY := "difficulty"
const GAMEPLAY_KEY_ADDITIONNAL_JUMPS := "additional_jumps"
const GAMEPLAY_SECTION_MOVEMENT := "movement"
const GAMEPLAY_KEY_AIR_STRAFE_MANEUVERABILITY := "air_strafe_maneuverability"

#---- STANDARD -----
#==== PUBLIC ====
var settings_presets := {
	"general": CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION,
	"controls": CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION,
	"audio": CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION,
	"video": CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION,
	"gameplay": CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
}  # name of the selected option preset

var settings_data := {
	"controls":
	{
		"mouse_sensitivity": 0.05,
		"crosshair_path": DEFAULT_CROSSHAIR,
		"crosshair_color": Color.white,
		"crosshair_size": 1
	},
	"gameplay": {
		"fov": 90, 
		"space_to_wall_ride": false, 
		"tutorial_level": TUTORIAL_LEVEL.all,
		"additionnal_jumps": 0,
		"air_strafe_maneuverability":4
	},
	"graphics":{
		"reflections":true,
		"glow":true
	}
}  # Misc data for parameters that can't be set directly

var first_start := false # true if the root config folder is absent (meaning that this is probablty the first launch of the game)

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	check_cfg_dir_init()
	load_current_settings()


##### PUBLIC METHODS #####
# checks if the cfg directories are created, and creates these if that's not the case
func check_cfg_dir_init() -> void:
	var dir := Directory.new()
	if not dir.dir_exists(ROOT_PRESETS_FOLDER):
		DebugUtils.log_create_directory(ROOT_PRESETS_FOLDER)
		first_start = true
		save_current_settings()
	if not dir.dir_exists(GENERAL_PRESETS_PATH):
		DebugUtils.log_create_directory(GENERAL_PRESETS_PATH)
	if not dir.dir_exists(INPUT_PRESETS_PATH):
		DebugUtils.log_create_directory(INPUT_PRESETS_PATH)
		_save_default_keyboard_layouts()
	if not dir.dir_exists(AUDIO_PRESETS_PATH):
		DebugUtils.log_create_directory(AUDIO_PRESETS_PATH)
	if not dir.dir_exists(VIDEO_PRESETS_PATH):
		DebugUtils.log_create_directory(VIDEO_PRESETS_PATH)
	if not dir.dir_exists(GAMEPLAY_PRESETS_PATH):
		DebugUtils.log_create_directory(GAMEPLAY_PRESETS_PATH)


func save_current_settings() -> void:
	check_cfg_dir_init()
	DebugUtils.log_save_cfg(
		_generate_cfg_root_file(),
		ROOT_PRESETS_FOLDER + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)
	save_general_settings()
	save_controls_settings()
	save_audio_settings()
	save_video_settings()
	save_gameplay_settings()


func save_general_settings() -> void:
	DebugUtils.log_save_cfg(
		generate_cfg_general_file(),
		GENERAL_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_controls_settings() -> void:
	DebugUtils.log_save_cfg(
		generate_cfg_input_file(),
		INPUT_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_audio_settings() -> void:
	DebugUtils.log_save_cfg(
		generate_cfg_audio_file(),
		AUDIO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_video_settings() -> void:
	DebugUtils.log_save_cfg(
		generate_cfg_video_file(),
		VIDEO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_gameplay_settings() -> void:
	DebugUtils.log_save_cfg(
		generate_cfg_gameplay_file(),
		GAMEPLAY_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func load_current_settings() -> void:
	_load_cfg_root_file(
		DebugUtils.log_load_cfg(ROOT_PRESETS_FOLDER + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)
	load_general_settings()
	load_controls_settings()
	load_audio_settings()
	load_video_settings()
	load_gameplay_settings()


func load_general_settings() -> void:
	load_cfg_general_file(
		DebugUtils.log_load_cfg(
			GENERAL_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
		)
	)


func load_controls_settings() -> void:
	load_inputs_cfg(
		DebugUtils.log_load_cfg(INPUT_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)


func load_audio_settings() -> void:
	load_cfg_audio_file(
		DebugUtils.log_load_cfg(AUDIO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)


func load_video_settings() -> void:
	load_cfg_video_file(
		DebugUtils.log_load_cfg(VIDEO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)


func load_gameplay_settings() -> void:
	load_cfg_gameplay_file(
		DebugUtils.log_load_cfg(
			GAMEPLAY_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
		)
	)


#---- INPUTS -----
# loads the CFG controls into the input map
func load_inputs_cfg(cfg: ConfigFile) -> void:
	if cfg != null:
		for section in CONTROLS_SETTINGS_CFG_MAPPER.keys():
			for key in CONTROLS_SETTINGS_CFG_MAPPER[section].keys():
				if _check_has_value(cfg, section, key):
					if InputMap.has_action(CONTROLS_SETTINGS_CFG_MAPPER[section][key]):  # remove the existing action if exists
						InputMap.action_erase_events(CONTROLS_SETTINGS_CFG_MAPPER[section][key])
						InputMap.action_add_event(
							CONTROLS_SETTINGS_CFG_MAPPER[section][key],
							_generate_input_from_cfg_val(cfg.get_value(section, key))
						)
		if _check_has_value(cfg, CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_SENSITIVITY):
			settings_data.controls.mouse_sensitivity = cfg.get_value(
				CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_SENSITIVITY
			)
		if _check_has_value(cfg, CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_CROSSHAIR_PATH):
			settings_data.controls.crosshair_path = cfg.get_value(
				CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_CROSSHAIR_PATH
			)
		if _check_has_value(
			cfg, CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_CROSSHAIR_COLOR
		):
			settings_data.controls.crosshair_color = cfg.get_value(
				CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_CROSSHAIR_COLOR
			)
		if _check_has_value(cfg, CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_CROSSHAIR_SIZE):
			settings_data.controls.crosshair_size = cfg.get_value(
				CONTROLS_SECTION_GENERAL, CONTROLS_SECTION_GENERAL_CROSSHAIR_SIZE
			)

	else:
		DebugUtils.log_stacktrace("No cfg inputs config", DebugUtils.LOG_LEVEL.warn)


# returns a cfg file from the inputs
func generate_cfg_input_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	for section in CONTROLS_SETTINGS_CFG_MAPPER.keys():
		for key in CONTROLS_SETTINGS_CFG_MAPPER[section].keys():
			cfg_file.set_value(
				section,
				key,
				_generate_cfg_input_from_action(CONTROLS_SETTINGS_CFG_MAPPER[section][key])
			)
	cfg_file.set_value(
		CONTROLS_SECTION_GENERAL,
		CONTROLS_SECTION_GENERAL_SENSITIVITY,
		settings_data.controls.mouse_sensitivity
	)
	cfg_file.set_value(
		CONTROLS_SECTION_GENERAL,
		CONTROLS_SECTION_GENERAL_CROSSHAIR_PATH,
		settings_data.controls.crosshair_path
	)
	cfg_file.set_value(
		CONTROLS_SECTION_GENERAL,
		CONTROLS_SECTION_GENERAL_CROSSHAIR_COLOR,
		settings_data.controls.crosshair_color
	)
	cfg_file.set_value(
		CONTROLS_SECTION_GENERAL,
		CONTROLS_SECTION_GENERAL_CROSSHAIR_SIZE,
		settings_data.controls.crosshair_size
	)
	return cfg_file


# sets the crosshair path
func set_crosshair_path(path: String) -> void:
	settings_data.controls.crosshair_path = path
	_emit_crosshair_changed()


# sets the crosshair color
func set_crosshair_color(color: Color) -> void:
	settings_data.controls.crosshair_color = color
	_emit_crosshair_changed()


# sets the crosshair color
func set_crosshair_size(size: float) -> void:
	settings_data.controls.crosshair_size = size
	_emit_crosshair_changed()


##### PROTECTED METHODS #####
func _check_has_value(cfg: ConfigFile, section: String, value: String) -> bool:
	if cfg.has_section(section) and (cfg.get_value(section, value) != null):
		return true
	else:
		DebugUtils.log_stacktrace(
			"No section %s or key %s in cfg root" % [section, value], DebugUtils.LOG_LEVEL.warn
		)
	return false


#---- ROOT -----
func _load_cfg_root_file(cfg: ConfigFile) -> void:
	if cfg != null:
		_load_cfg_subfolders(cfg, ROOT_SECTION_GENERAL, "general")
		_load_cfg_subfolders(cfg, ROOT_SECTION_CONTROLS, "controls")
		_load_cfg_subfolders(cfg, ROOT_SECTION_AUDIO, "audio")
		_load_cfg_subfolders(cfg, ROOT_SECTION_VIDEO, "video")
	else:
		DebugUtils.log_stacktrace("No cfg root config", DebugUtils.LOG_LEVEL.warn)


func _load_cfg_subfolders(cfg: ConfigFile, section: String, settings_preset_key: String) -> void:
	if (
		cfg.has_section(section)
		and cfg.get_value(section, ROOT_KEY_PRESET) != null
		and settings_preset_key in settings_presets
	):
		settings_presets[settings_preset_key] = cfg.get_value(section, ROOT_KEY_PRESET)
	else:
		DebugUtils.log_stacktrace(
			"No section %s or key %s in cfg root" % [section, ROOT_KEY_PRESET],
			DebugUtils.LOG_LEVEL.warn
		)


func _generate_cfg_root_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	cfg_file.set_value(ROOT_SECTION_GENERAL, ROOT_KEY_PRESET, settings_presets.general)
	cfg_file.set_value(ROOT_SECTION_CONTROLS, ROOT_KEY_PRESET, settings_presets.controls)
	cfg_file.set_value(ROOT_SECTION_AUDIO, ROOT_KEY_PRESET, settings_presets.audio)
	cfg_file.set_value(ROOT_SECTION_VIDEO, ROOT_KEY_PRESET, settings_presets.video)
	return cfg_file


#---- GENERAL -----
func load_cfg_general_file(cfg: ConfigFile) -> void:
	if cfg != null:
		if (
			cfg.has_section(GENERAL_SECTION_LANGUAGE)
			and cfg.get_value(GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT) != null
		):
			TranslationServer.set_locale(
				cfg.get_value(GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT)
			)
		else:
			DebugUtils.log_stacktrace(
				(
					"No section %s or key %s in cfg root"
					% [GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT]
				),
				DebugUtils.LOG_LEVEL.warn
			)
	else:
		DebugUtils.log_stacktrace("No cfg general config", DebugUtils.LOG_LEVEL.warn)


func generate_cfg_general_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	cfg_file.set_value(
		GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT, TranslationServer.get_locale()
	)
	return cfg_file


#---- INPUTS -----
func _generate_input_from_cfg_val(val: String) -> InputEvent:
	var input: InputEvent
	if val.begins_with(KEY_CFG_PREFIX):
		input = InputEventKey.new()
		input.scancode = int(val.substr(KEY_CFG_PREFIX.length() - 1))
	elif val.begins_with(MOUSE_BUTTON_CFG_PREFIX):
		input = InputEventMouseButton.new()
		input.button_index = int(val.substr(MOUSE_BUTTON_CFG_PREFIX.length() - 1))
	elif val.begins_with(JOYPAD_CFG_PREFIX):
		input = InputEventJoypadButton.new()
		input.button_index = int(val.substr(JOYPAD_CFG_PREFIX.length() - 1))
	return input


func _generate_cfg_input_from_action(action: String) -> String:
	var input = InputMap.get_action_list(action)[0]
	if input is InputEventKey:
		return KEY_CFG_PREFIX + str(input.scancode)
	elif input is InputEventMouseButton:
		return MOUSE_BUTTON_CFG_PREFIX + str(input.button_index)
	elif input is InputEventJoypadButton:
		return JOYPAD_CFG_PREFIX + str(input.button_index)
	return ""


func _emit_crosshair_changed() -> void:
	SignalManager.emit_update_crosshair(
		settings_data.controls.crosshair_path,
		settings_data.controls.crosshair_color,
		settings_data.controls.crosshair_size
	)

func _save_default_keyboard_layouts() -> void:
	var dir = Directory.new()
	if dir.open(DEFAULT_INPUTS_FOLDER) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir(): 
				dir.copy(DEFAULT_INPUTS_FOLDER + file_name, INPUT_PRESETS_PATH + file_name)
			file_name = dir.get_next()
	else:
		DebugUtils.log_stacktrace("error trying to open the default inputs folder %s" % DEFAULT_INPUTS_FOLDER, DebugUtils.LOG_LEVEL.error)
	

#---- AUDIO -----
func load_cfg_audio_file(cfg: ConfigFile) -> void:
	if cfg != null:
		# Main
		if (
			cfg.has_section(AUDIO_SECTION_MAIN)
			and cfg.get_value(AUDIO_SECTION_MAIN, AUDIO_KEY_VOLUME) != null
		):
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index(GlobalConstants.MAIN_BUS),
				linear2db(cfg.get_value(AUDIO_SECTION_MAIN, AUDIO_KEY_VOLUME))
			)
		else:
			DebugUtils.log_stacktrace(
				"No section %s or key %s in cfg root" % [AUDIO_SECTION_MAIN, AUDIO_KEY_VOLUME],
				DebugUtils.LOG_LEVEL.warn
			)
		if (
			cfg.has_section(AUDIO_SECTION_MAIN)
			and cfg.get_value(AUDIO_SECTION_MAIN, AUDIO_KEY_UNMUTED) != null
		):
			AudioServer.set_bus_mute(
				AudioServer.get_bus_index(GlobalConstants.MAIN_BUS),
				not cfg.get_value(AUDIO_SECTION_MAIN, AUDIO_KEY_UNMUTED)
			)
		else:
			DebugUtils.log_stacktrace(
				"No section %s or key %s in cfg root" % [AUDIO_SECTION_MAIN, AUDIO_KEY_UNMUTED],
				DebugUtils.LOG_LEVEL.warn
			)
		# BGM
		if (
			cfg.has_section(AUDIO_SECTION_BGM)
			and cfg.get_value(AUDIO_SECTION_BGM, AUDIO_KEY_VOLUME) != null
		):
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index(GlobalConstants.BGM_BUS),
				linear2db(cfg.get_value(AUDIO_SECTION_BGM, AUDIO_KEY_VOLUME))
			)
		else:
			DebugUtils.log_stacktrace(
				"No section %s or key %s in cfg root" % [AUDIO_SECTION_BGM, AUDIO_KEY_VOLUME],
				DebugUtils.LOG_LEVEL.warn
			)
		if (
			cfg.has_section(AUDIO_SECTION_BGM)
			and cfg.get_value(AUDIO_SECTION_BGM, AUDIO_KEY_UNMUTED) != null
		):
			AudioServer.set_bus_mute(
				AudioServer.get_bus_index(GlobalConstants.BGM_BUS),
				not cfg.get_value(AUDIO_SECTION_BGM, AUDIO_KEY_UNMUTED)
			)
		else:
			DebugUtils.log_stacktrace(
				"No section %s or key %s in cfg root" % [AUDIO_SECTION_BGM, AUDIO_KEY_UNMUTED],
				DebugUtils.LOG_LEVEL.warn
			)
		# Effects
		if (
			cfg.has_section(AUDIO_SECTION_EFFECTS)
			and cfg.get_value(AUDIO_SECTION_EFFECTS, AUDIO_KEY_VOLUME) != null
		):
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS),
				linear2db(cfg.get_value(AUDIO_SECTION_EFFECTS, AUDIO_KEY_VOLUME))
			)
		else:
			DebugUtils.log_stacktrace(
				"No section %s or key %s in cfg root" % [AUDIO_SECTION_EFFECTS, AUDIO_KEY_VOLUME],
				DebugUtils.LOG_LEVEL.warn
			)
		if (
			cfg.has_section(AUDIO_SECTION_EFFECTS)
			and cfg.get_value(AUDIO_SECTION_EFFECTS, AUDIO_KEY_UNMUTED) != null
		):
			AudioServer.set_bus_mute(
				AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS),
				not cfg.get_value(AUDIO_SECTION_EFFECTS, AUDIO_KEY_UNMUTED)
			)
		else:
			DebugUtils.log_stacktrace(
				"No section %s or key %s in cfg root" % [AUDIO_SECTION_EFFECTS, AUDIO_KEY_UNMUTED],
				DebugUtils.LOG_LEVEL.warn
			)
	else:
		DebugUtils.log_stacktrace("No cfg audio config", DebugUtils.LOG_LEVEL.warn)


func generate_cfg_audio_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	# Main
	cfg_file.set_value(
		AUDIO_SECTION_MAIN,
		AUDIO_KEY_VOLUME,
		db2linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))
		)
	)
	cfg_file.set_value(
		AUDIO_SECTION_MAIN,
		AUDIO_KEY_UNMUTED,
		not AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))
	)
	# BGM
	cfg_file.set_value(
		AUDIO_SECTION_BGM,
		AUDIO_KEY_VOLUME,
		db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS)))
	)
	cfg_file.set_value(
		AUDIO_SECTION_BGM,
		AUDIO_KEY_UNMUTED,
		not AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))
	)
	# effects
	cfg_file.set_value(
		AUDIO_SECTION_EFFECTS,
		AUDIO_KEY_VOLUME,
		db2linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))
		)
	)
	cfg_file.set_value(
		AUDIO_SECTION_EFFECTS,
		AUDIO_KEY_UNMUTED,
		not AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))
	)
	return cfg_file


#---- VIDEO -----
func load_cfg_video_file(cfg: ConfigFile) -> void:
	if cfg != null:
		if _check_has_value(cfg, VIDEO_SECTION_MODE, VIDEO_KEY_MODE):
			OS.window_fullscreen = cfg.get_value(VIDEO_SECTION_MODE, VIDEO_KEY_MODE)
		if _check_has_value(cfg, VIDEO_SECTION_QUALITY, VIDEO_KEY_GLOW):
			settings_data.graphics.glow = cfg.get_value(VIDEO_SECTION_QUALITY, VIDEO_KEY_GLOW)
		if _check_has_value(cfg, VIDEO_SECTION_QUALITY, VIDEO_KEY_REFLECTIONS):
			settings_data.graphics.reflections = cfg.get_value(VIDEO_SECTION_QUALITY, VIDEO_KEY_REFLECTIONS)
	else:
		DebugUtils.log_stacktrace("No cfg video config", DebugUtils.LOG_LEVEL.warn)


func generate_cfg_video_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	cfg_file.set_value(VIDEO_SECTION_MODE, VIDEO_KEY_MODE, OS.window_fullscreen)
	cfg_file.set_value(VIDEO_SECTION_QUALITY, VIDEO_KEY_GLOW, settings_data.graphics.glow)
	cfg_file.set_value(VIDEO_SECTION_QUALITY, VIDEO_KEY_REFLECTIONS, settings_data.graphics.reflections)
	return cfg_file


#---- GAMEPLAY -----
func load_cfg_gameplay_file(cfg: ConfigFile) -> void:
	if cfg != null:
		if _check_has_value(cfg, GAMEPLAY_SECTION_GAMEPLAY, GAMEPLAY_KEY_FOV):
			SettingsUtils.settings_data.gameplay.fov = cfg.get_value(
				GAMEPLAY_SECTION_GAMEPLAY, GAMEPLAY_KEY_FOV
			)
		if _check_has_value(cfg, GAMEPLAY_SECTION_GAMEPLAY, GAMEPLAY_KEY_SPACE_WALL_RIDE):
			SettingsUtils.settings_data.gameplay.space_to_wall_ride = cfg.get_value(
				GAMEPLAY_SECTION_GAMEPLAY, GAMEPLAY_KEY_SPACE_WALL_RIDE
			)
		if _check_has_value(cfg, GAMEPLAY_SECTION_TUTORIAL, GAMEPLAY_KEY_LEVEL):
			SettingsUtils.settings_data.gameplay.tutorial_level = cfg.get_value(
				GAMEPLAY_SECTION_TUTORIAL, GAMEPLAY_KEY_LEVEL
			)
		if _check_has_value(cfg, GAMEPLAY_SECTION_DIFFICULTY, GAMEPLAY_KEY_ADDITIONNAL_JUMPS):
			SettingsUtils.settings_data.gameplay.additionnal_jumps = cfg.get_value(
				GAMEPLAY_SECTION_DIFFICULTY, GAMEPLAY_KEY_ADDITIONNAL_JUMPS
			)
		if _check_has_value(cfg, GAMEPLAY_SECTION_MOVEMENT, GAMEPLAY_KEY_AIR_STRAFE_MANEUVERABILITY):
			SettingsUtils.settings_data.gameplay.air_strafe_maneuverability = cfg.get_value(
				GAMEPLAY_SECTION_MOVEMENT, GAMEPLAY_KEY_AIR_STRAFE_MANEUVERABILITY
			)
	else:
		DebugUtils.log_stacktrace("No cfg gameplay config", DebugUtils.LOG_LEVEL.warn)


func generate_cfg_gameplay_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	cfg_file.set_value(
		GAMEPLAY_SECTION_GAMEPLAY, GAMEPLAY_KEY_FOV, SettingsUtils.settings_data.gameplay.fov
	)
	cfg_file.set_value(
		GAMEPLAY_SECTION_GAMEPLAY,
		GAMEPLAY_KEY_SPACE_WALL_RIDE,
		SettingsUtils.settings_data.gameplay.space_to_wall_ride
	)
	cfg_file.set_value(
		GAMEPLAY_SECTION_TUTORIAL,
		GAMEPLAY_KEY_LEVEL,
		SettingsUtils.settings_data.gameplay.tutorial_level
	)
	cfg_file.set_value(
		GAMEPLAY_SECTION_DIFFICULTY,
		GAMEPLAY_KEY_ADDITIONNAL_JUMPS,
		SettingsUtils.settings_data.gameplay.additionnal_jumps
	)
	cfg_file.set_value(
		GAMEPLAY_SECTION_MOVEMENT,
		GAMEPLAY_KEY_AIR_STRAFE_MANEUVERABILITY,
		SettingsUtils.settings_data.gameplay.air_strafe_maneuverability
	)
	return cfg_file


# sets the fov
func set_fov(fov: float) -> void:
	settings_data.gameplay.fov = fov
	SignalManager.emit_update_fov(fov)


# toggles the space to wall ride option
func set_space_to_wall_ride(enabled: bool) -> void:
	settings_data.gameplay.space_to_wall_ride = enabled
	SignalManager.emit_update_wall_ride_strategy()
