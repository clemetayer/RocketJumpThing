# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the end level ui

##### VARIABLES #####
const end_level_ui_path := "res://Game/Common/Menus/EndLevel/end_level_ui.tscn"
var end_level_ui


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = end_level_ui_path
	.before()
	end_level_ui = load(end_level_ui_path).instance()


func after():
	end_level_ui.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	end_level_ui._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.END_REACHED, end_level_ui, "_on_SignalManager_end_reached")).is_true()


# TODO : _unpause hard to test because of the get_tree()


func test_create_filter_auto_effect() -> void:
	var auto_effect = end_level_ui._create_filter_auto_effect()
	assert_bool(auto_effect is HalfFilterEffectManager)
	assert_float(auto_effect.TIME).is_equal(end_level_ui.FADE_IN_TIME)
	auto_effect.free()

# TODO : _on_SignalManager_end_reached, _on_NextButton_pressed, _on_RestartButton_pressed, _on_MainMenuButton_pressed hard to test because of the get_tree and tweens
