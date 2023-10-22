# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends PresetsTest
# Tests the audio presets


##### TESTS #####
#---- PRE/POST -----
func before():
	presets_path = "res://test/UnitTests/MenusTests/SettingsMenu/Video/presets_video_mock.tscn"
	.before()


#---- TESTS -----
func test_get_init_selected_cfg() -> void:
	assert_object(presets._generate_cfg_file()).is_equal(SettingsUtils.generate_cfg_input_file())


func test_generate_cfg_file() -> void:
	assert_str(presets._get_init_selected_cfg()).is_equal(SettingsUtils.settings_presets.video)


func test_get_config_path() -> void:
	assert_str(presets._get_config_path()).is_equal(SettingsUtils.VIDEO_PRESETS_PATH)

# FIXME :fairly hard to test _apply_preset in this case (maybe by mocking log_load_cfg ?)
