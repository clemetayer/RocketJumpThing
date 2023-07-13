# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# level select menu test

##### VARIABLES #####
const runtime_utils_path := "res://test/UnitTests/ToolsTests/RuntimeUtils/runtime_utils_mock.tscn"
const scenes_manager_path := "res://test/UnitTests/ToolsTests/ScenesManager/scenes_manager_mock.tscn"
const level_select_path := "res://Game/Common/Menus/LevelSelect/level_select.tscn"
var level_select

##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = level_select_path
	.before()
	level_select = load(level_select_path).instance()
	level_select._ready()


func after():
	level_select.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	level_select._connect_signals()
	assert_bool(level_select.onready_paths.return.is_connected("pressed",level_select,"_on_button_pressed"))

func test_init_grid() -> void:
	# -- setup
	level_select.onready_paths.grid.add_child(Control.new())
	var levels_data = LevelsData.new()
	var level_1 = LevelData.new()
	var level_2 = LevelData.new()
	levels_data.LEVELS = [level_1,level_2]
	var runtime_utils = mock(runtime_utils_path)
	runtime_utils.levels_data = levels_data
	level_select._runtime_utils = runtime_utils
	# -- exec
	level_select._init_grid()
	# -- test
	assert_int(level_select.onready_paths.grid.get_child_count()).is_equal(2)
	for level_idx in range(level_select.onready_paths.grid.get_child_count()):
		assert_int(level_select.onready_paths.grid.get_child(level_idx).LEVEL_IDX).is_equal(level_idx)
		assert_object(level_select.onready_paths.grid.get_child(level_idx).LEVELS_DATA).is_equal(levels_data)

func test_on_button_pressed() -> void:
	var scenes_manager_mock = mock(scenes_manager_path)
	do_return(null).on(scenes_manager_mock).load_main_menu() 
	level_select._scenes_manager = scenes_manager_mock
	verify(scenes_manager_mock, 1).load_main_menu()
