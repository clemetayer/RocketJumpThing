# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the scene manager

##### VARIABLES #####
const scenes_manager_path := "res://test/UnitTests/ToolsTests/ScenesManager/scenes_manager_mock.tscn"
var scenes_manager
var mock


##### TESTS #####
#---- PRE/POST -----
func before_test():
	mock = mock(scenes_manager_path)
	do_return(null).on(mock)._goto_scene(mock.MAIN_MENU_PATH)
	do_return(null).on(mock)._goto_scene("l1")
	do_return(null).on(mock)._goto_scene("l2")
	do_return(null).on(mock)._goto_scene("l3")


func before():
	element_path = scenes_manager_path
	.before()
	scenes_manager = load(scenes_manager_path).instance()
	scenes_manager._current_level_data = _generate_test_LevelsData()

func after():
	scenes_manager.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_has_next_level() -> void:
	scenes_manager._current_level_idx = 0
	assert_bool(scenes_manager.has_next_level()).is_true()
	scenes_manager._current_level_idx = 2
	assert_bool(scenes_manager.has_next_level()).is_false()


func test_has_previous_level() -> void:
	scenes_manager._current_level_idx = 2
	assert_bool(scenes_manager.has_previous_level()).is_true()
	scenes_manager._current_level_idx = 0
	assert_bool(scenes_manager.has_previous_level()).is_false()


func test_load_main_menu() -> void:
	mock.load_main_menu()
	verify(mock, 2)._goto_scene(mock.MAIN_MENU_PATH) 
	assert_object(mock._current_level_data).is_null()
	assert_int(mock._current_level_idx).is_equal(0)

func test_level_switch() -> void:
	_test_load_level_0()
	_test_next_level()
	_test_prev_level()


func _test_load_level_0() -> void:
	var levels = _generate_test_LevelsData()
	mock.load_level(levels, 0)
	verify(mock, 1)._goto_scene("l1") 
	assert_object(mock._current_level_data).is_equal(levels)
	assert_int(mock._current_level_idx).is_equal(0)


func _test_next_level() -> void:
	var original_levels = mock._current_level_data
	mock.next_level()
	verify(mock, 1)._goto_scene("l2")  
	assert_object(mock._current_level_data).is_equal(original_levels)
	assert_int(mock._current_level_idx).is_equal(1)


func _test_prev_level() -> void:
	var original_levels = mock._current_level_data
	mock.previous_level()
	verify(mock, 1)._goto_scene("l1")  
	assert_object(mock._current_level_data).is_equal(original_levels)
	assert_int(mock._current_level_idx).is_equal(0)

#---- UTILS -----
func _generate_test_LevelsData() -> LevelsData:
	var levels := LevelsData.new()
	var level1 := LevelData.new()
	level1.SCENE_PATH = "l1"
	var level2 := LevelData.new()
	level2.SCENE_PATH = "l2"
	var level3 := LevelData.new()
	level3.SCENE_PATH = "l3"
	levels.LEVELS = [level1,level2,level3]
	return levels
