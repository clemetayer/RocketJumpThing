	# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the main menu background

##### VARIABLES #####
const main_menu_back_path := "res://Game/Common/Menus/MainMenu/main_menu_background.tscn"
var main_menu_back


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = main_menu_back_path
	.before()
	main_menu_back = load(main_menu_back_path).instance()
	main_menu_back._ready()

func after():
	main_menu_back.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signal() -> void:
	main_menu_back._connect_signals()
	assert_bool(MenuNavigator.is_connected(MenuNavigator.MENU_ACTIVATED_SIGNAL_NAME,main_menu_back,"_on_MenuNavigator_menu_activated"))

# cannot really test _init_skybox, _change_cubes_color and _on_MenuNavigator_menu_activated

