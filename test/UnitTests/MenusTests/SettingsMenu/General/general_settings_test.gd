# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the general settings tab

##### VARIABLES #####
const general_path := "res://Game/Common/Menus/SettingsMenu/General/general_settings.tscn"
var general


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = general_path
	.before()
	general = load(general_path).instance()
	general._ready()


func after():
	.after()
	general.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_tr() -> void:
	general._init_tr()
	assert_str(general.onready_paths.language.label.text).is_equal(
		tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_OPTION)
	)
	assert_str(general.onready_paths.language.category.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_CATEGORY)
	)


func test_init_option() -> void:
	var locales := TranslationServer.get_loaded_locales()
	general.onready_paths.language.options.clear()
	general._init_options()
	assert_int(general.onready_paths.language.options.get_item_count()).is_equal(locales.size())


func test_connect_signals() -> void:
	general._connect_signals()
	assert_bool(general.onready_paths.language.options.is_connected("item_selected", general, "_on_Options_item_selected")).is_true()

# Kind of weird to test _on_Options_item_selected because it is directly "linked" to the init_option