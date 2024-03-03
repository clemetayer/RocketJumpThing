# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the menu navigator

##### VARIABLES #####
const menu_navigator_path := "res://Game/Common/Menus/menu_navigator.tscn"
var menu_navigator


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = menu_navigator_path
	.before()
	menu_navigator = load(menu_navigator_path).instance()
	menu_navigator._ready()

func after():
	menu_navigator.free()
	.after()

func after_test():
	pass

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_visible() -> void:
	menu_navigator.visible = true
	menu_navigator._state = menu_navigator.MENU.main
	menu_navigator._init_visible()
	assert_bool(menu_navigator.visible).is_false()
	assert_int(menu_navigator._state).is_equal(menu_navigator.MENU.hidden)

func test_connect_signals() -> void:
	menu_navigator._connect_signals()
	# Main
	assert_bool(menu_navigator.onready_paths.main.is_connected("level_select_requested",menu_navigator,"_on_MainMenu_LevelSelectRequested"))
	assert_bool(menu_navigator.onready_paths.main.is_connected("settings_requested",menu_navigator,"_on_SettingsRequested"))
	# Pause
	assert_bool(menu_navigator.onready_paths.pause.is_connected("settings_requested",menu_navigator,"_on_SettingsRequested"))
	# Level select
	assert_bool(menu_navigator.onready_paths.level_select.is_connected("return_to_prev_menu",menu_navigator,"_on_return"))
	# Settings
	assert_bool(menu_navigator.onready_paths.settings.is_connected("return_to_prev_menu",menu_navigator,"_on_return"))

# cannot test _manage_input because of the get_tree() call

func test_toggle_pause_enabled() -> void:
	menu_navigator._pause_enabled = false
	menu_navigator.toggle_pause_enabled(true)
	assert_bool(menu_navigator._pause_enabled).is_true()
	menu_navigator._pause_enabled = true
	menu_navigator.toggle_pause_enabled(false)
	assert_bool(menu_navigator._pause_enabled).is_false()

func test_is_protected_menu() -> void:
	assert_bool(menu_navigator._is_protected_menu(menu_navigator.MENU.hidden)).is_true()
	assert_bool(menu_navigator._is_protected_menu(menu_navigator.MENU.main)).is_true()
	assert_bool(menu_navigator._is_protected_menu(menu_navigator.MENU.pause)).is_false()
