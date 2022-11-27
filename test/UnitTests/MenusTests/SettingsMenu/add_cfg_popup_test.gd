# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the setting's add cfg popup

##### VARIABLES #####
const add_cfg_popup_path := "res://Game/Common/Menus/SettingsMenu/add_cfg_popup.tscn"
var add_cfg_popup


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = add_cfg_popup_path
	.before()
	add_cfg_popup = load(add_cfg_popup_path).instance()
	add_cfg_popup._init()
	add_cfg_popup._ready()


func after():
	.after()
	add_cfg_popup.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_tr() -> void:
	add_cfg_popup._init_tr()
	assert_str(add_cfg_popup.window_title).is_equal(
		tr(TranslationKeys.MENU_SETTINGS_ADD_CFG_POPUP_TITLE)
	)
	assert_str(add_cfg_popup.dialog_text).is_equal(
		tr(TranslationKeys.MENU_SETTINGS_ADD_CFG_POPUP_LABEL)
	)


func test_signals() -> void:
	add_cfg_popup._init()
	add_cfg_popup._ready()
	assert_bool(SignalManager.is_connected(SignalManager.ADD_CFG_POPUP, add_cfg_popup, "_on_SignalManager_add_cfg_popup")).is_true()
	assert_bool(add_cfg_popup.is_connected("confirmed", add_cfg_popup, "_on_popup_confirmed")).is_true()
	assert_bool(add_cfg_popup.onready_paths.line_edit.is_connected("text_changed", add_cfg_popup, "_on_LineEdit_text_changed")).is_true()


func test_on_SignalManager_add_cfg_popup() -> void:
	var TEST_PATH := "test"
	add_cfg_popup._cfg = null
	add_cfg_popup._on_SignalManager_add_cfg_popup(TEST_PATH, ConfigFile.new())
	assert_object(add_cfg_popup._cfg).is_not_null()
	assert_str(add_cfg_popup._path).is_equal(TEST_PATH)
	# assert_bool(add_cfg_popup.visible).is_true() # FIXME : in test mode, it does not show as visible


func test_on_LineEdit_text_changed() -> void:
	var INVALID_FILENAME := "test/test"
	var VALID_FILENAME := "test"
	# Invalid text
	add_cfg_popup._on_LineEdit_text_changed(INVALID_FILENAME)
	assert_bool(add_cfg_popup.get_close_button().disabled).is_true()
	# Valid text
	add_cfg_popup._on_LineEdit_text_changed(VALID_FILENAME)
	assert_bool(add_cfg_popup.get_close_button().disabled).is_false()
