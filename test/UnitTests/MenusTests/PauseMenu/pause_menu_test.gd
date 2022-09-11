# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the pause menu

##### VARIABLES #####
const pause_menu_path := "res://Game/Common/Menus/PauseMenu/pause_menu.tscn"
var pause_menu


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = pause_menu_path
	.before()
	pause_menu = load(pause_menu_path).instance()


func after():
	.after()
	pause_menu.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_create_filter_auto_effect() -> void:
	var auto_effect = pause_menu._create_filter_auto_effect()
	assert_bool(auto_effect is HalfFilterEffectManager)
	assert_float(auto_effect.TIME).is_equal(pause_menu.FADE_IN_TIME)
	auto_effect.free()
