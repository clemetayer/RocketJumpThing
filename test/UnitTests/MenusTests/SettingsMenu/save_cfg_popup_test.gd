# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the setting's save  cfg popup

##### VARIABLES #####
const save_cfg_popup_path := "res://Game/Common/Menus/SettingsMenu/save_cfg_popup.tscn"
var save_cfg_popup


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = save_cfg_popup_path
	.before()
	save_cfg_popup = load(save_cfg_popup_path).instance()


func after():
	.after()
	save_cfg_popup.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	save_cfg_popup._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.SAVE_CFG_POPUP, save_cfg_popup, "_on_SignalManager_save_cfg_popup")).is_true()
	assert_bool(save_cfg_popup.is_connected("confirmed", save_cfg_popup, "_on_popup_confirmed"))


func test_on_SignalManager_save_cfg_popup() -> void:
	var TEST_PATH := "test_path"
	var TEST_NAME := "test_name"
	save_cfg_popup._cfg = null
	save_cfg_popup._on_SignalManager_save_cfg_popup(TEST_PATH, TEST_NAME, ConfigFile.new())
	assert_object(save_cfg_popup._cfg).is_not_null()
	assert_str(save_cfg_popup._path).is_equal(TEST_PATH)
	assert_str(save_cfg_popup._name).is_equal(TEST_NAME)
