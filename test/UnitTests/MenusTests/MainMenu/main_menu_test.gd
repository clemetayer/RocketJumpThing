# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the main menu

##### VARIABLES #####
const main_menu_path := "res://Game/Common/Menus/MainMenu/main_menu.tscn"
var main_menu


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = main_menu_path
	.before()
	main_menu = load(main_menu_path).instance()
	main_menu._ready()

func after():
	main_menu.free()
	.after()

# Nothing to test