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
	pause_menu._ready()


func after():
	.after()
	pause_menu.free()


#---- TESTS -----
func test_pause_menu_set_labels() -> void:
	pause_menu._set_labels()
	assert_str(pause_menu.onready_paths.resume.text).is_equal(tr(TranslationKeys.MENU_RESUME))
	assert_str(pause_menu.onready_paths.restart.text).is_equal(tr(TranslationKeys.MENU_RESTART))
	assert_str(pause_menu.onready_paths.options.text).is_equal(tr(TranslationKeys.MENU_OPTIONS))
	assert_str(pause_menu.onready_paths.main_menu.text).is_equal(tr(TranslationKeys.MAIN_MENU))
