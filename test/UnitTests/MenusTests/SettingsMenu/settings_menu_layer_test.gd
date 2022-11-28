# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Test of the settings menu layer function

##### VARIABLES #####
const settings_menu_path := "res://Game/Common/Menus/SettingsMenu/settings_menu_layer.tscn"
var settings_menu


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = settings_menu_path
	.before()
	settings_menu = load(settings_menu_path).instance()
	settings_menu._ready()


func after():
	.after()
	settings_menu.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	settings_menu._connect_signals()
	assert_bool(
		settings_menu.onready_paths.settings_menu.is_connected(
			"return_signal", self, "_on_SettingsMenu_return"
		)
	)
