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
	mock.levels = {"main_menu": "main_menu", "game_scenes": {"list1": ["l1", "l2", "l3"]}}
	do_return(null).on(mock)._goto_scene("main_menu")
	do_return(null).on(mock)._goto_scene("l1")
	do_return(null).on(mock)._goto_scene("l2")
	do_return(null).on(mock)._goto_scene("l3")


func before():
	element_path = scenes_manager_path
	.before()
	scenes_manager = load(scenes_manager_path).instance()
	scenes_manager.levels = {"main_menu": "main_menu", "game_scenes": {"list1": ["l1", "l2", "l3"]}}


func after():
	scenes_manager.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_has_next_level() -> void:
	scenes_manager._current_level_list = "list1"
	scenes_manager._current_level_idx = 0
	assert_bool(scenes_manager.has_next_level()).is_true()
	scenes_manager._current_level_list = "list1"
	scenes_manager._current_level_idx = 2
	assert_bool(scenes_manager.has_next_level()).is_false()


func test_has_previous_level() -> void:
	scenes_manager._current_level_list = "list1"
	scenes_manager._current_level_idx = 2
	assert_bool(scenes_manager.has_previous_level()).is_true()
	scenes_manager._current_level_list = "list1"
	scenes_manager._current_level_idx = 0
	assert_bool(scenes_manager.has_previous_level()).is_false()


func test_load_main_menu() -> void:
	mock.load_main_menu()
	verify(mock, 2)._goto_scene(mock.MAIN_MENU)  # FIXME : for some reason it is called one more time somewhere...
	assert_str(mock._current_level_list).is_equal("")
	assert_int(mock._current_level_idx).is_equal(0)


func test_level_switch() -> void:
	_test_load_level_0()
	_test_next_level()
	_test_prev_level()


func _test_load_level_0() -> void:
	mock.load_level("list1", 0)
	verify(mock, 2)._goto_scene("l1")  # FIXME : for some reason it is called one more time somewhere...
	assert_str(mock._current_level_list).is_equal("list1")
	assert_int(mock._current_level_idx).is_equal(0)


func _test_next_level() -> void:
	mock.next_level()
	verify(mock, 2)._goto_scene("l2")  # FIXME : for some reason it is called one more time somewhere...
	assert_str(mock._current_level_list).is_equal("list1")
	assert_int(mock._current_level_idx).is_equal(1)


func _test_prev_level() -> void:
	mock.previous_level()
	verify(mock, 3)._goto_scene("l1")  # FIXME : for some reason it is called one more time somewhere...
	assert_str(mock._current_level_list).is_equal("list1")
	assert_int(mock._current_level_idx).is_equal(0)
