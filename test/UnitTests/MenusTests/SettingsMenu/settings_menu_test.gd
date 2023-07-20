# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the settings menu root

##### VARIABLES #####
const settings_menu_path := "res://Game/Common/Menus/SettingsMenu/settings_menu.tscn"
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
		settings_menu.onready_paths.return.is_connected(
			"pressed", settings_menu, "_on_Return_pressed"
		)
	)


func test_init_tab_names() -> void:
	settings_menu._init_tab_names()
	for child_idx in range(settings_menu.onready_paths.tabs.get_children().size()):
		assert_str(settings_menu.onready_paths.tabs.get_tab_title(child_idx)).is_equal(
			tr(settings_menu.onready_paths.tabs.get_child(child_idx).TAB_NAME)
		)		
