# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the global world environment parameters

##### VARIABLES #####
const scene_path := "res://test/UnitTests/MapElementsTests/common_world_environment_mock.tscn"
var scene


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = scene_path
	.before()
	scene = load(scene_path).instance()
	scene._ready()

func after():
	scene.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	scene._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_SETTINGS,scene,"_on_SignalManager_update_settings")).is_true()

func test_init_performance_parameters() -> void:
	SettingsUtils.settings_data.graphics.glow = false
	SettingsUtils.settings_data.graphics.reflections = true
	scene._init_performance_parameters()
	assert_bool(scene.environment.glow_enabled).is_false()
	assert_bool(scene.environment.ss_reflections_enabled).is_true()
