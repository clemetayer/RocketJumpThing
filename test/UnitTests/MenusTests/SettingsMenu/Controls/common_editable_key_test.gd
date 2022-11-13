# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the common editable key scene

##### VARIABLES #####
const common_key_path := "res://Game/Common/Menus/SettingsMenu/Controls/common_editable_key.tscn"
var common_key


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = common_key_path
	.before()
	common_key = load(common_key_path).instance()
	common_key.ACTION_NAME = GlobalTestUtilities.TEST_ACTION  # to not crash on _ready
	common_key._ready()


func after():
	.after()
	common_key.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	common_key._connect_signals()
	assert_bool(common_key.onready_paths.action.is_connected("pressed", common_key, "_on_action_pressed")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_KEYS, common_key, "_on_SignalManager_update_keys")).is_true()


func test_set_action_name() -> void:
	common_key._set_action_name(GlobalTestUtilities.TEST_ACTION)
	assert_str(common_key.onready_paths.label.text).is_equal(GlobalTestUtilities.TEST_ACTION)
	assert_str(common_key.onready_paths.action.text).is_equal(GlobalTestUtilities.TEST_ACTION_KEY)
	assert_str(common_key.ACTION_NAME).is_equal(GlobalTestUtilities.TEST_ACTION)

# Not really usefull to test _on_action_pressed and _on_SignalManager_update_keys
