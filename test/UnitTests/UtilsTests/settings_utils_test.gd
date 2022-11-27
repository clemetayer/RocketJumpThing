# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GdUnitTestSuite
# Tests the SettingsUtils singleton

##### VARIABLES #####
const FLOAT_APPROX := 0.5  # an approximation for testing float values

##### TESTS #####
#---- TESTS -----
#==== ACTUAL TESTS =====
# Actually useless/dangerous to test check_cfg_dir_init because it would require to delete existing preset directories


func test_load_inputs_cfg() -> void:
	# init
	## Full init
	var cfg := ConfigFile.new()
	for section in SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER.keys():
		for key in SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER[section].keys():
			cfg.set_value(
				section,
				key,
				SettingsUtils._generate_cfg_input_from_action(
					SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER[section][key]
				)
			)
	## Some overrides
	cfg.set_value("movement", "forward", SettingsUtils.KEY_CFG_PREFIX + str(KEY_ESCAPE))
	cfg.set_value("action", "shoot", SettingsUtils.KEY_CFG_PREFIX + str(KEY_2))
	cfg.set_value("ui", "pause", SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(BUTTON_MIDDLE))
	# test
	SettingsUtils.load_inputs_cfg(cfg)
	assert_int(InputMap.get_action_list(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["movement"]["forward"])[0].scancode).is_equal(
		KEY_ESCAPE
	)
	assert_int(InputMap.get_action_list(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["action"]["shoot"])[0].scancode).is_equal(
		KEY_2
	)
	assert_int(InputMap.get_action_list(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["ui"]["pause"])[0].button_index).is_equal(
		BUTTON_MIDDLE
	)


func test_generate_cfg_input_file() -> void:
	# init
	var input_fwd := InputEventKey.new()
	input_fwd.scancode = KEY_A
	var input_shoot := InputEventKey.new()
	input_shoot.scancode = KEY_2
	var input_pause := InputEventMouseButton.new()
	input_pause.button_index = BUTTON_LEFT
	if InputMap.has_action(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["movement"]["forward"]):  # remove the existing action if exists
		InputMap.action_erase_events(
			SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["movement"]["forward"]
		)
		InputMap.action_add_event(
			SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["movement"]["forward"], input_fwd
		)
	if InputMap.has_action(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["action"]["shoot"]):  # remove the existing action if exists
		InputMap.action_erase_events(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["action"]["shoot"])
		InputMap.action_add_event(
			SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["action"]["shoot"], input_shoot
		)
	if InputMap.has_action(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["ui"]["pause"]):  # remove the existing action if exists
		InputMap.action_erase_events(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["ui"]["pause"])
		InputMap.action_add_event(
			SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["ui"]["pause"], input_pause
		)
	# test
	var cfg := SettingsUtils.generate_cfg_input_file()
	assert_str(cfg.get_value("movement", "forward")).is_equal(
		SettingsUtils.KEY_CFG_PREFIX + str(KEY_A)
	)
	assert_str(cfg.get_value("action", "shoot")).is_equal(SettingsUtils.KEY_CFG_PREFIX + str(KEY_2))
	assert_str(cfg.get_value("ui", "pause")).is_equal(
		SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(BUTTON_LEFT)
	)


func test_load_cfg_root_file() -> void:
	var preset_name := "test"
	# init
	var cfg := ConfigFile.new()
	cfg.set_value(SettingsUtils.ROOT_SECTION_CONTROLS, SettingsUtils.ROOT_KEY_PRESET, preset_name)
	# test
	SettingsUtils._load_cfg_root_file(cfg)
	assert_str(SettingsUtils.settings_presets.controls).is_equal(preset_name)


func test_generate_cfg_root_file() -> void:
	var preset_name := "test"
	# init
	SettingsUtils.settings_presets.controls = preset_name
	# test
	var cfg := SettingsUtils._generate_cfg_root_file()
	assert_str(cfg.get_value(SettingsUtils.ROOT_SECTION_CONTROLS, SettingsUtils.ROOT_KEY_PRESET)).is_equal(
		preset_name
	)


func test_load_cfg_general_file() -> void:
	var locale := "en"
	# init
	var cfg := ConfigFile.new()
	cfg.set_value(
		SettingsUtils.GENERAL_SECTION_LANGUAGE, SettingsUtils.GENERAL_SECTION_LANGUAGE_TEXT, locale
	)
	# test
	SettingsUtils._load_cfg_general_file(cfg)
	assert_str(TranslationServer.get_locale()).is_equal(locale)


func test_generate_cfg_general_file() -> void:
	var locale := "en"
	# init
	TranslationServer.set_locale(locale)
	# test
	var cfg := SettingsUtils._generate_cfg_general_file()
	assert_str(cfg.get_value(SettingsUtils.GENERAL_SECTION_LANGUAGE, SettingsUtils.GENERAL_SECTION_LANGUAGE_TEXT)).is_equal(
		locale
	)


func test_generate_input_from_cfg_val() -> void:
	assert_int(SettingsUtils._generate_input_from_cfg_val(SettingsUtils.KEY_CFG_PREFIX + str(KEY_A)).scancode).is_equal(
		KEY_A
	)
	assert_int(SettingsUtils._generate_input_from_cfg_val(SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(BUTTON_LEFT)).button_index).is_equal(
		BUTTON_LEFT
	)
	assert_int(SettingsUtils._generate_input_from_cfg_val(SettingsUtils.JOYPAD_CFG_PREFIX + str(JOY_BUTTON_0)).button_index).is_equal(
		JOY_BUTTON_0
	)


func test_generate_cfg_input_from_action() -> void:
	# init
	var input_key := InputEventKey.new()
	input_key.scancode = KEY_A
	var input_mouse := InputEventMouseButton.new()
	input_mouse.button_index = BUTTON_LEFT
	var input_joy := InputEventJoypadButton.new()
	input_joy.button_index = JOY_BUTTON_1
	# test
	## key
	if InputMap.has_action(GlobalTestUtilities.TEST_ACTION):  # remove the existing action if exists
		InputMap.action_erase_events(GlobalTestUtilities.TEST_ACTION)
		InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input_key)
	assert_str(SettingsUtils._generate_cfg_input_from_action(GlobalTestUtilities.TEST_ACTION)).is_equal(
		SettingsUtils.KEY_CFG_PREFIX + str(input_key.scancode)
	)
	## mouse
	if InputMap.has_action(GlobalTestUtilities.TEST_ACTION):  # remove the existing action if exists
		InputMap.action_erase_events(GlobalTestUtilities.TEST_ACTION)
		InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input_mouse)
	assert_str(SettingsUtils._generate_cfg_input_from_action(GlobalTestUtilities.TEST_ACTION)).is_equal(
		SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(input_mouse.button_index)
	)
	## joypad
	if InputMap.has_action(GlobalTestUtilities.TEST_ACTION):  # remove the existing action if exists
		InputMap.action_erase_events(GlobalTestUtilities.TEST_ACTION)
		InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input_joy)
	assert_str(SettingsUtils._generate_cfg_input_from_action(GlobalTestUtilities.TEST_ACTION)).is_equal(
		SettingsUtils.JOYPAD_CFG_PREFIX + str(input_joy.button_index)
	)


func test_load_cfg_audio_file() -> void:
	var main_volume := 50.0
	var main_mute := false
	var bgm_volume := 20.2
	var bgm_mute := true
	var effects_volume := 75.6
	var effects_mute := false
	# init
	var cfg := ConfigFile.new()
	## main
	cfg.set_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_VOLUME, main_volume)
	cfg.set_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_MUTE, main_mute)
	## bgm
	cfg.set_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_VOLUME, bgm_volume)
	cfg.set_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_MUTE, bgm_mute)
	## effects
	cfg.set_value(
		SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_VOLUME, effects_volume
	)
	cfg.set_value(SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_MUTE, effects_mute)
	# test
	SettingsUtils._load_cfg_audio_file(cfg)
	## main
	assert_float(db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS)))).is_equal_approx(
		main_volume, FLOAT_APPROX
	)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))).is_equal(
		main_mute
	)
	## bgm
	assert_float(db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS)))).is_equal_approx(
		bgm_volume, FLOAT_APPROX
	)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))).is_equal(
		bgm_mute
	)
	## effects
	assert_float(db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS)))).is_equal_approx(
		effects_volume, FLOAT_APPROX
	)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))).is_equal(
		effects_mute
	)


func test_generate_cfg_audio_file() -> void:
	var main_volume := 50.0
	var main_mute := false
	var bgm_volume := 20.2
	var bgm_mute := true
	var effects_volume := 75.6
	var effects_mute := false
	# init
	## main
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), linear2db(main_volume)
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), main_mute)
	## bgm
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.BGM_BUS), linear2db(bgm_volume)
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS), bgm_mute)
	## effects
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), linear2db(effects_volume)
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), effects_mute)
	# test
	var cfg := SettingsUtils._generate_cfg_audio_file()
	## main
	assert_float(cfg.get_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_VOLUME)).is_equal_approx(
		main_volume, FLOAT_APPROX
	)
	assert_bool(cfg.get_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_MUTE)).is_equal(
		main_mute
	)
	## bgm
	assert_float(cfg.get_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_VOLUME)).is_equal_approx(
		bgm_volume, FLOAT_APPROX
	)
	assert_bool(cfg.get_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_MUTE)).is_equal(
		bgm_mute
	)
	## main
	assert_float(cfg.get_value(SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_VOLUME)).is_equal_approx(
		effects_volume, FLOAT_APPROX
	)
	assert_bool(cfg.get_value(SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_MUTE)).is_equal(
		effects_mute
	)


func test_load_cfg_video_file() -> void:
	var fullscreen := true
	# init
	var cfg := ConfigFile.new()
	cfg.set_value(SettingsUtils.VIDEO_SECTION_MODE, SettingsUtils.VIDEO_KEY_MODE, fullscreen)
	# test
	SettingsUtils._load_cfg_video_file(cfg)
	assert_bool(OS.window_fullscreen).is_equal(fullscreen)


func test_generate_cfg_video_file() -> void:
	var fullscreen := false
	# init
	OS.window_fullscreen = fullscreen
	# test
	var cfg := SettingsUtils._generate_cfg_video_file()
	assert_bool(cfg.get_value(SettingsUtils.VIDEO_SECTION_MODE, SettingsUtils.VIDEO_KEY_MODE)).is_equal(
		fullscreen
	)
