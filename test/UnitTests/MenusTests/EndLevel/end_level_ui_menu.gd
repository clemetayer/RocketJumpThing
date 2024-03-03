# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the end level ui

##### VARIABLES #####
const end_level_ui_path := "res://Game/Common/Menus/EndLevel/end_level_menu.tscn"
var end_level_ui


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = end_level_ui_path
	.before()
	end_level_ui = load(end_level_ui_path).instance()
	end_level_ui._ready()


func after():
	end_level_ui.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_set_labels() -> void:
	end_level_ui._set_labels()
	assert_str(end_level_ui.onready_paths.next_scene_button.text).is_equal(
		tr(TranslationKeys.MENU_NEXT_LEVEL)
	)
	assert_str(end_level_ui.onready_paths.main_menu_button.text).is_equal(
		tr(TranslationKeys.MAIN_MENU)
	)
	assert_str(end_level_ui.onready_paths.restart_button.text).is_equal(
		tr(TranslationKeys.MENU_RESTART)
	)


func test_connect_signals() -> void:
	end_level_ui._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.END_REACHED, end_level_ui, "_on_SignalManager_end_reached")).is_true()
