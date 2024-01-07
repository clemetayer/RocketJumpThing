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
	cfg.set_value(
		SettingsUtils.CONTROLS_SECTION_GENERAL,
		SettingsUtils.CONTROLS_SECTION_GENERAL_SENSITIVITY,
		1.5
	)
	cfg.set_value(
		SettingsUtils.CONTROLS_SECTION_GENERAL,
		SettingsUtils.CONTROLS_SECTION_GENERAL_CROSSHAIR_PATH,
		"test"
	)
	cfg.set_value(
		SettingsUtils.CONTROLS_SECTION_GENERAL,
		SettingsUtils.CONTROLS_SECTION_GENERAL_CROSSHAIR_SIZE,
		1.3
	)
	cfg.set_value(
		SettingsUtils.CONTROLS_SECTION_GENERAL,
		SettingsUtils.CONTROLS_SECTION_GENERAL_CROSSHAIR_COLOR,
		Color.azure
	)
	## Some overrides
	cfg.set_value("movement", "forward", SettingsUtils.KEY_CFG_PREFIX + str(KEY_ESCAPE))
	cfg.set_value("action", "shoot", SettingsUtils.KEY_CFG_PREFIX + str(KEY_2))
	cfg.set_value("ui", "pause", SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(BUTTON_MIDDLE))
	# test
	SettingsUtils.load_inputs_cfg(cfg)
	(
		assert_int(
			(
				InputMap.get_action_list(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["movement"]["forward"])[0].scancode
			)
		).is_equal(KEY_ESCAPE)
	)
	(
		assert_int(
			(
				InputMap.get_action_list(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["action"]["shoot"])[0].scancode
			)
		).is_equal(KEY_2)
	)
	(
		assert_int(
			(
				InputMap.get_action_list(SettingsUtils.CONTROLS_SETTINGS_CFG_MAPPER["ui"]["pause"])[0].button_index
			)
		).is_equal(BUTTON_MIDDLE)
	)
	assert_float(
		(
			SettingsUtils.settings_data.controls.mouse_sensitivity
		)
	).is_equal_approx(1.5, FLOAT_APPROX)
	assert_str(
		(
			SettingsUtils.settings_data.controls.crosshair_path
		)
	).is_equal("test")
	assert_object(
		(
			SettingsUtils.settings_data.controls.crosshair_color
		)
	).is_equal(Color.azure)
	assert_float(
		(
			SettingsUtils.settings_data.controls.crosshair_size
		)
	).is_equal_approx(1.3, FLOAT_APPROX)


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
	SettingsUtils.set_crosshair_path("test_2")
	SettingsUtils.set_crosshair_size(1.4)
	SettingsUtils.set_crosshair_color(Color.beige)
	SettingsUtils.settings_data.controls.mouse_sensitivity = 1.2
	# test
	var cfg := SettingsUtils.generate_cfg_input_file()
	assert_str(cfg.get_value("movement", "forward")).is_equal(
		SettingsUtils.KEY_CFG_PREFIX + str(KEY_A)
	)
	assert_str(cfg.get_value("action", "shoot")).is_equal(SettingsUtils.KEY_CFG_PREFIX + str(KEY_2))
	assert_str(cfg.get_value("ui", "pause")).is_equal(
		SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(BUTTON_LEFT)
	)
	assert_float(cfg.get_value("general","mouse_sensitivity")).is_equal_approx(1.2, FLOAT_APPROX)
	assert_float(cfg.get_value("general","crosshair_size")).is_equal_approx(1.4, FLOAT_APPROX)
	assert_str(cfg.get_value("general","crosshair_path")).is_equal("test_2")
	assert_object(cfg.get_value("general","crosshair_color")).is_equal(Color.beige)


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
	(
		assert_str(
			cfg.get_value(SettingsUtils.ROOT_SECTION_CONTROLS, SettingsUtils.ROOT_KEY_PRESET)
		).is_equal(preset_name)
	)


func testload_cfg_general_file() -> void:
	var locale := "fr"
	# init
	var cfg := ConfigFile.new()
	cfg.set_value(
		SettingsUtils.GENERAL_SECTION_LANGUAGE, SettingsUtils.GENERAL_SECTION_LANGUAGE_TEXT, locale
	)
	# test
	SettingsUtils.load_cfg_general_file(cfg)
	assert_str(TranslationServer.get_locale()).is_equal(locale)


func testgenerate_cfg_general_file() -> void:
	var locale := "fr"
	# init
	TranslationServer.set_locale(locale)
	# test
	var cfg := SettingsUtils.generate_cfg_general_file()
	(
		assert_str(
			cfg.get_value(
				SettingsUtils.GENERAL_SECTION_LANGUAGE, SettingsUtils.GENERAL_SECTION_LANGUAGE_TEXT
			)
		).is_equal(locale)
	)


func test_generate_input_from_cfg_val() -> void:
	(
		assert_int(
			(
				SettingsUtils._generate_input_from_cfg_val(SettingsUtils.KEY_CFG_PREFIX + str(KEY_A)).scancode
			)
		).is_equal(KEY_A)
	)
	(
		assert_int(
			(
				SettingsUtils._generate_input_from_cfg_val(
					SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(BUTTON_LEFT)
				).button_index
			)
		).is_equal(BUTTON_LEFT)
	)
	(
		assert_int(
			(
				SettingsUtils._generate_input_from_cfg_val(SettingsUtils.JOYPAD_CFG_PREFIX + str(JOY_BUTTON_0)).button_index
			)
		).is_equal(JOY_BUTTON_0)
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
	(
		assert_str(SettingsUtils._generate_cfg_input_from_action(GlobalTestUtilities.TEST_ACTION)).is_equal(SettingsUtils.KEY_CFG_PREFIX + str(input_key.scancode))
	)
	## mouse
	if InputMap.has_action(GlobalTestUtilities.TEST_ACTION):  # remove the existing action if exists
		InputMap.action_erase_events(GlobalTestUtilities.TEST_ACTION)
		InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input_mouse)
	(
		assert_str(SettingsUtils._generate_cfg_input_from_action(GlobalTestUtilities.TEST_ACTION)).is_equal(SettingsUtils.MOUSE_BUTTON_CFG_PREFIX + str(input_mouse.button_index))
	)
	## joypad
	if InputMap.has_action(GlobalTestUtilities.TEST_ACTION):  # remove the existing action if exists
		InputMap.action_erase_events(GlobalTestUtilities.TEST_ACTION)
		InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input_joy)
	(
		assert_str(SettingsUtils._generate_cfg_input_from_action(GlobalTestUtilities.TEST_ACTION)).is_equal(SettingsUtils.JOYPAD_CFG_PREFIX + str(input_joy.button_index))
	)


func testload_cfg_audio_file() -> void:
	var main_volume := 50.0
	var main_unmute := false
	var bgm_volume := 20.2
	var bgm_unmute := true
	var effects_volume := 75.6
	var effects_unmute := false
	# init
	var cfg := ConfigFile.new()
	## main
	cfg.set_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_VOLUME, main_volume)
	cfg.set_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_UNMUTED, main_unmute)
	## bgm
	cfg.set_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_VOLUME, bgm_volume)
	cfg.set_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_UNMUTED, bgm_unmute)
	## effects
	cfg.set_value(
		SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_VOLUME, effects_volume
	)
	cfg.set_value(
		SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_UNMUTED, effects_unmute
	)
	# test
	SettingsUtils.load_cfg_audio_file(cfg)
	## main
	(
		assert_float(
			db2linear(
				AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))
			)
		).is_equal_approx(main_volume, FLOAT_APPROX)
	)
	(
		assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))).is_equal(not main_unmute)
	)
	## bgm
	(
		assert_float(
			db2linear(
				AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))
			)
		).is_equal_approx(bgm_volume, FLOAT_APPROX)
	)
	(
		assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))).is_equal(not bgm_unmute)
	)
	## effects
	(
		assert_float(
			db2linear(
				AudioServer.get_bus_volume_db(
					AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS)
				)
			)
		).is_equal_approx(effects_volume, FLOAT_APPROX)
	)
	(
		assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))).is_equal(not effects_unmute)
	)


func testgenerate_cfg_audio_file() -> void:
	var main_volume := 50.0
	var main_unmute := false
	var bgm_volume := 20.2
	var bgm_unmute := true
	var effects_volume := 75.6
	var effects_unmute := false
	# init
	## main
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), linear2db(main_volume)
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), not main_unmute)
	## bgm
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.BGM_BUS), linear2db(bgm_volume)
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS), not bgm_unmute)
	## effects
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), linear2db(effects_volume)
	)
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), not effects_unmute
	)
	# test
	var cfg := SettingsUtils.generate_cfg_audio_file()
	## main
	(
		assert_float(
			cfg.get_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_VOLUME)
		).is_equal_approx(main_volume, FLOAT_APPROX)
	)
	(
		assert_bool(
			cfg.get_value(SettingsUtils.AUDIO_SECTION_MAIN, SettingsUtils.AUDIO_KEY_UNMUTED)
		).is_equal(main_unmute)
	)
	## bgm
	(
		assert_float(cfg.get_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_VOLUME)).is_equal_approx(bgm_volume, FLOAT_APPROX)
	)
	(
		assert_bool(cfg.get_value(SettingsUtils.AUDIO_SECTION_BGM, SettingsUtils.AUDIO_KEY_UNMUTED)).is_equal(bgm_unmute)
	)
	## main
	(
		assert_float(
			cfg.get_value(SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_VOLUME)
		).is_equal_approx(effects_volume, FLOAT_APPROX)
	)
	(
		assert_bool(
			cfg.get_value(SettingsUtils.AUDIO_SECTION_EFFECTS, SettingsUtils.AUDIO_KEY_UNMUTED)
		).is_equal(effects_unmute)
	)


func testload_cfg_video_file() -> void:
	var fullscreen := true
	# init
	var cfg := ConfigFile.new()
	cfg.set_value(SettingsUtils.VIDEO_SECTION_MODE, SettingsUtils.VIDEO_KEY_MODE, fullscreen)
	# test
	SettingsUtils.load_cfg_video_file(cfg)
	assert_bool(OS.window_fullscreen).is_equal(fullscreen)


func testgenerate_cfg_video_file() -> void:
	var fullscreen := false
	# init
	OS.window_fullscreen = fullscreen
	# test
	var cfg := SettingsUtils.generate_cfg_video_file()
	assert_bool(cfg.get_value(SettingsUtils.VIDEO_SECTION_MODE, SettingsUtils.VIDEO_KEY_MODE)).is_equal(fullscreen)


func testload_cfg_gameplay_file() -> void:
	# init
	var cfg := ConfigFile.new()
	cfg.set_value(SettingsUtils.GAMEPLAY_SECTION_GAMEPLAY, SettingsUtils.GAMEPLAY_KEY_FOV, 91.2)
	cfg.set_value(SettingsUtils.GAMEPLAY_SECTION_GAMEPLAY, SettingsUtils.GAMEPLAY_KEY_SPACE_WALL_RIDE, true)
	cfg.set_value(SettingsUtils.GAMEPLAY_SECTION_TUTORIAL, SettingsUtils.GAMEPLAY_KEY_LEVEL, 2)
	cfg.set_value(SettingsUtils.GAMEPLAY_SECTION_DIFFICULTY, SettingsUtils.GAMEPLAY_KEY_ADDITIONNAL_JUMPS, 4)
	# test
	SettingsUtils.load_cfg_gameplay_file(cfg)
	assert_float(SettingsUtils.settings_data.gameplay.fov).is_equal_approx(91.2, FLOAT_APPROX)
	assert_bool(SettingsUtils.settings_data.gameplay.space_to_wall_ride).is_true()
	assert_int(SettingsUtils.settings_data.gameplay.tutorial_level).is_equal(2)
	assert_int(SettingsUtils.settings_data.gameplay.additionnal_jumps).is_equal(4)


func testgenerate_cfg_gameplay_file() -> void:
	# init
	SettingsUtils.settings_data.gameplay.fov = 89.5
	SettingsUtils.settings_data.gameplay.space_to_wall_ride = false
	SettingsUtils.settings_data.gameplay.tutorial_level = 0
	SettingsUtils.settings_data.gameplay.additionnal_jumps = 5
	# test
	var cfg := SettingsUtils.generate_cfg_gameplay_file()
	assert_float(cfg.get_value(SettingsUtils.GAMEPLAY_SECTION_GAMEPLAY, SettingsUtils.GAMEPLAY_KEY_FOV)).is_equal_approx(89.5, FLOAT_APPROX)
	assert_bool(cfg.get_value(SettingsUtils.GAMEPLAY_SECTION_GAMEPLAY, SettingsUtils.GAMEPLAY_KEY_SPACE_WALL_RIDE)).is_false()
	assert_int(cfg.get_value(SettingsUtils.GAMEPLAY_SECTION_TUTORIAL, SettingsUtils.GAMEPLAY_KEY_LEVEL)).is_equal(0)
	assert_int(cfg.get_value(SettingsUtils.GAMEPLAY_SECTION_DIFFICULTY, SettingsUtils.GAMEPLAY_KEY_ADDITIONNAL_JUMPS)).is_equal(5)