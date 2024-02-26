# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests a level icon in the level select menu

##### VARIABLES #####
const PREVIEW_ICON_PATH := "res://icon.png"
const scenes_manager_path := "res://test/UnitTests/ToolsTests/ScenesManager/scenes_manager_mock.tscn"
const level_icon_path := "res://Game/Common/Menus/LevelSelect/level_icon.tscn"
var level_icon

##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = level_icon_path
	.before()
	level_icon = load(level_icon_path).instance()
	level_icon._ready()


func after():
	level_icon.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	level_icon._connect_signals()
	assert_bool(level_icon.onready_paths.button.is_connected("pressed",level_icon,"_on_button_pressed"))
	assert_bool(SignalManager.is_connected(SignalManager.TRANSLATION_UPDATED, level_icon, "_on_SignalManager_translation_updated")).is_true()

func test_init_level_icon() -> void:
	var levels := LevelsData.new()
	var level := LevelData.new()
	level.NAME = "test"
	level.BEST_TIME = 86197.7
	level.LAST_TIME = 91224.1
	level.PREVIEW_PATH = PREVIEW_ICON_PATH
	level.UNLOCKED = true
	levels.LEVELS = [level]
	level_icon.LEVELS_DATA = levels
	level_icon.LEVEL_IDX = 0
	level_icon._init_level_icon()
	assert_object(level_icon.onready_paths.button.icon).is_not_null()
	assert_bool(level_icon.onready_paths.button.disabled).is_false()
	assert_str(level_icon.onready_paths.level_name.text).is_equal("test")
	assert_str(level_icon.onready_paths.last_time.text).is_equal(tr(TranslationKeys.MENU_LEVEL_SELECT_LAST_TIME) % "01:31:224")
	assert_str(level_icon.onready_paths.best_time.text).is_equal(tr(TranslationKeys.MENU_LEVEL_SELECT_BEST_TIME) % "01:26:197")

func test_on_button_pressed() -> void:
	var scenes_manager_mock = mock(scenes_manager_path)
	do_return(null).on(scenes_manager_mock).load_level(level_icon.LEVELS_DATA, level_icon.LEVEL_IDX) 
	level_icon._scenes_manager = scenes_manager_mock
	level_icon._on_button_pressed()
	verify(scenes_manager_mock, 2).load_level(level_icon.LEVELS_DATA, level_icon.LEVEL_IDX) # FIXME : for some reason it is called one more time somewhere...
