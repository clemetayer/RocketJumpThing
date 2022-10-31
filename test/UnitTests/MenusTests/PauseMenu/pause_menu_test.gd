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
