# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the setting's change key popup

##### VARIABLES #####
const change_key_popup_path := "res://Game/Common/Menus/SettingsMenu/change_key_popup.tscn"
var change_key_popup


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = change_key_popup_path
	.before()
	change_key_popup = load(change_key_popup_path).instance()
	change_key_popup._ready()
	# resets the test input
	var input := InputEventKey.new()
	input.scancode = KEY_T
	if InputMap.has_action(GlobalTestUtilities.TEST_ACTION):  # remove the existing action if exists
		InputMap.action_erase_events(GlobalTestUtilities.TEST_ACTION)
		InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input)


func after():
	.after()
	change_key_popup.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	change_key_popup._connect_signals()
	assert_bool(
		SignalManager.is_connected(
			SignalManager.CHANGE_KEY_POPUP, change_key_popup, "_on_SignalManager_change_key_popup"
		)
	)


func test_on_SignalManager_change_key_popup() -> void:
	change_key_popup._on_SignalManager_change_key_popup(GlobalTestUtilities.TEST_ACTION)
	assert_str(change_key_popup.ACTION).is_equal(GlobalTestUtilities.TEST_ACTION)
	# assert_bool(change_key_popup.visible).is_true() # FIXME : popup centered not setting the node as visible


func test_set_popup_text() -> void:
	change_key_popup.ACTION = GlobalTestUtilities.TEST_ACTION
	change_key_popup._set_popup_text()
	assert_str(change_key_popup.onready_paths.message.get_text()).is_equal(
		(
			tr("Enter an action for %s")
			% [
				TextUtils.BBCode_color_text(
					tr(GlobalTestUtilities.TEST_ACTION), Color.yellow.to_html()
				)
			]
		)
	)


func test_set_key() -> void:
	change_key_popup._set_key(GlobalTestUtilities.TEST_ACTION_KEY)
	assert_str(change_key_popup.onready_paths.key.get_text()).is_equal(
		TextUtils.BBCode_color_text(
			TextUtils.BBCode_center_text(tr(GlobalTestUtilities.TEST_ACTION_KEY)),
			Color.aquamarine.to_html()
		)
	)


func test_change_key() -> void:
	change_key_popup.ACTION = GlobalTestUtilities.TEST_ACTION
	assert_int(InputMap.get_action_list(GlobalTestUtilities.TEST_ACTION)[0].scancode).is_equal(
		KEY_T
	)
	var input := InputEventKey.new()
	input.scancode = KEY_A
	change_key_popup._change_key(input)
	assert_int(InputMap.get_action_list(GlobalTestUtilities.TEST_ACTION)[0].scancode).is_equal(
		KEY_A
	)
	# Resets the input
	InputMap.action_erase_event(
		GlobalTestUtilities.TEST_ACTION,
		InputMap.get_action_list(GlobalTestUtilities.TEST_ACTION)[0]
	)
	input.scancode = KEY_T
	InputMap.action_add_event(GlobalTestUtilities.TEST_ACTION, input)
