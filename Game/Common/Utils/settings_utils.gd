extends Node
# A bunch of methods to load or save settings

##### VARIABLES #####
#---- CONSTANTS -----
#==== GLOBAL =====
const CFG_FILE_EXTENSION := ".cfg"
const CURRENT_PRESET_FILE_NAME := "current"
const REGEX_PATTERN_CFG_FILE := "^(?!" + CURRENT_PRESET_FILE_NAME + ".cfg$).+\\.(?:cfg)$"
const ROOT_PRESETS_FOLDER := "user://conf/"
const ROOT_SECTION_CONTROLS := "controls"
const ROOT_KEY_PRESET := "preset"

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

#---- STANDARD -----
#==== PUBLIC ====
var settings_presets := {"controls": CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION}  # name of the selected option preset


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	load_current_settings()

	##### PUBLIC METHODS #####
	# checks if the cfg directories are created, and creates these if that's not the case


func check_cfg_dir_init() -> void:
	var dir := Directory.new()
	if not dir.dir_exists(ROOT_PRESETS_FOLDER):
		DebugUtils.log_create_directory(ROOT_PRESETS_FOLDER)
	if not dir.dir_exists(GENERAL_PRESETS_PATH):
		DebugUtils.log_create_directory(GENERAL_PRESETS_PATH)
	if not dir.dir_exists(INPUT_PRESETS_PATH):
		DebugUtils.log_create_directory(INPUT_PRESETS_PATH)
	if not dir.dir_exists(AUDIO_PRESETS_PATH):
		DebugUtils.log_create_directory(AUDIO_PRESETS_PATH)
	if not dir.dir_exists(VIDEO_PRESETS_PATH):
		DebugUtils.log_create_directory(VIDEO_PRESETS_PATH)


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


func save_general_settings() -> void:
	DebugUtils.log_save_cfg(
		_generate_cfg_general_file(),
		GENERAL_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_controls_settings() -> void:
	DebugUtils.log_save_cfg(
		generate_cfg_input_file(),
		INPUT_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_audio_settings() -> void:
	DebugUtils.log_save_cfg(
		_generate_cfg_audio_file(),
		AUDIO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func save_video_settings() -> void:
	DebugUtils.log_save_cfg(
		_generate_cfg_video_file(),
		VIDEO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
	)


func load_current_settings() -> void:
	_load_cfg_root_file(
		DebugUtils.log_load_cfg(ROOT_PRESETS_FOLDER + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)
	load_general_settings()
	load_controls_settings()
	load_audio_settings()
	load_video_settings()


func load_general_settings() -> void:
	_load_cfg_general_file(
		DebugUtils.log_load_cfg(
			GENERAL_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION
		)
	)


func load_controls_settings() -> void:
	load_inputs_cfg(
		DebugUtils.log_load_cfg(INPUT_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)


func load_audio_settings() -> void:
	_load_cfg_audio_file(
		DebugUtils.log_load_cfg(AUDIO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)


func load_video_settings() -> void:
	_load_cfg_video_file(
		DebugUtils.log_load_cfg(VIDEO_PRESETS_PATH + CURRENT_PRESET_FILE_NAME + CFG_FILE_EXTENSION)
	)


#---- INPUTS -----
# loads the CFG controls into the input map
func load_inputs_cfg(cfg: ConfigFile) -> void:
	if cfg != null:
		for section in CONTROLS_SETTINGS_CFG_MAPPER.keys():
			for key in CONTROLS_SETTINGS_CFG_MAPPER[section].keys():
				if cfg.has_section(section) and cfg.get_value(section, key) != null:
					if InputMap.has_action(CONTROLS_SETTINGS_CFG_MAPPER[section][key]):  # remove the existing action if exists
						InputMap.action_erase_events(CONTROLS_SETTINGS_CFG_MAPPER[section][key])
						InputMap.action_add_event(
							CONTROLS_SETTINGS_CFG_MAPPER[section][key],
							_generate_input_from_cfg_val(cfg.get_value(section, key))
						)
				else:
					Logger.warn("No section %s or key %s in cfg inputs" % [section, key])
	else:
		Logger.warn("No cfg inputs config")


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
	return cfg_file


##### PROTECTED METHODS #####
#---- ROOT -----
func _load_cfg_root_file(cfg: ConfigFile) -> void:
	if cfg != null:
		if (
			cfg.has_section(ROOT_SECTION_CONTROLS)
			and cfg.get_value(ROOT_SECTION_CONTROLS, ROOT_KEY_PRESET) != null
		):
			settings_presets.controls = cfg.get_value(ROOT_SECTION_CONTROLS, ROOT_KEY_PRESET)
		else:
			Logger.warn(
				"No section %s or key %s in cfg root" % [ROOT_SECTION_CONTROLS, ROOT_KEY_PRESET]
			)
	else:
		Logger.warn("No cfg root config")


func _generate_cfg_root_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	cfg_file.set_value(ROOT_SECTION_CONTROLS, ROOT_KEY_PRESET, settings_presets.controls)
	return cfg_file


#---- GENERAL -----
func _load_cfg_general_file(cfg: ConfigFile) -> void:
	if cfg != null:
		if (
			cfg.has_section(GENERAL_SECTION_LANGUAGE)
			and cfg.get_value(GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT) != null
		):
			TranslationServer.set_locale(
				cfg.get_value(GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT)
			)
		else:
			Logger.warn(
				(
					"No section %s or key %s in cfg general"
					% [GENERAL_SECTION_LANGUAGE, GENERAL_SECTION_LANGUAGE_TEXT]
				)
			)
	else:
		Logger.warn("No cfg general config")


func _generate_cfg_general_file() -> ConfigFile:
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


#---- AUDIO -----
func _load_cfg_audio_file(cfg: ConfigFile) -> void:
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
			Logger.warn(
				"No section %s or key %s in cfg audio" % [AUDIO_SECTION_MAIN, AUDIO_KEY_VOLUME]
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
			Logger.warn(
				"No section %s or key %s in cfg audio" % [AUDIO_SECTION_MAIN, AUDIO_KEY_UNMUTED]
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
			Logger.warn(
				"No section %s or key %s in cfg audio" % [AUDIO_SECTION_BGM, AUDIO_KEY_VOLUME]
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
			Logger.warn(
				"No section %s or key %s in cfg audio" % [AUDIO_SECTION_BGM, AUDIO_KEY_UNMUTED]
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
			Logger.warn(
				"No section %s or key %s in cfg audio" % [AUDIO_SECTION_EFFECTS, AUDIO_KEY_UNMUTED]
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
			Logger.warn(
				"No section %s or key %s in cfg audio" % [AUDIO_SECTION_EFFECTS, AUDIO_KEY_UNMUTED]
			)
	else:
		Logger.warn("No cfg audio config")


func _generate_cfg_audio_file() -> ConfigFile:
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
func _load_cfg_video_file(cfg: ConfigFile) -> void:
	if cfg != null:
		if (
			cfg.has_section(VIDEO_SECTION_MODE)
			and cfg.get_value(VIDEO_SECTION_MODE, VIDEO_KEY_MODE) != null
		):
			OS.window_fullscreen = cfg.get_value(VIDEO_SECTION_MODE, VIDEO_KEY_MODE)
		else:
			Logger.warn(
				"No section %s or key %s in cfg video" % [VIDEO_SECTION_MODE, VIDEO_KEY_MODE]
			)
	else:
		Logger.warn("No cfg video config")


func _generate_cfg_video_file() -> ConfigFile:
	var cfg_file := ConfigFile.new()
	cfg_file.set_value(VIDEO_SECTION_MODE, VIDEO_KEY_MODE, OS.window_fullscreen)
	return cfg_file
