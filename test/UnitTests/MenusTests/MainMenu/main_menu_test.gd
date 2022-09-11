# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the main menu

##### VARIABLES #####
const main_menu_path := "res://Game/Common/Menus/MainMenu/main_menu.tscn"
var main_menu


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = main_menu_path
	.before()
	main_menu = load(main_menu_path).instance()


func after():
	main_menu.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_disable_pause() -> void:
	main_menu._disable_pause()
	assert_bool(PauseMenu.ENABLED).is_false()


func test_enable_mouse_visible() -> void:
	main_menu._enable_mouse_visible()
	assert_int(Input.get_mouse_mode()).is_equal(Input.MOUSE_MODE_VISIBLE)
