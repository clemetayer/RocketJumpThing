# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GdUnitTestSuite
# tests for the static functions in the FunctionUtils static class

const FUNCTION_UTILS_JSON_PATH := "res://test/UnitTests/UtilsTests/function_utils_test.json"


##### TESTS #####
#---- TESTS -----
#==== ACTUAL TESTS =====
func test_check_in_epsilon() -> void:
	assert_bool(FunctionUtils.check_in_epsilon(0.25, 0.0, 0.5)).is_true()
	assert_bool(FunctionUtils.check_in_epsilon(-0.25, 0.0, 0.5)).is_true()
	assert_bool(FunctionUtils.check_in_epsilon(0.75, 0.0, 0.5)).is_false()
	assert_bool(FunctionUtils.check_in_epsilon(-0.75, 0.0, 0.5)).is_false()
	assert_bool(FunctionUtils.check_in_epsilon(0.5, 0.0, 0.5)).is_false()
	assert_bool(FunctionUtils.check_in_epsilon(-0.5, 0.0, 0.5)).is_false()
	assert_bool(FunctionUtils.check_in_epsilon(0.5, 0.0, 0.5, true)).is_true()
	assert_bool(FunctionUtils.check_in_epsilon(-0.5, 0.0, 0.5, true)).is_true()


func test_load_json() -> void:
	var data = FunctionUtils.load_json(FUNCTION_UTILS_JSON_PATH)
	assert_bool(data.obj_bool).is_true()
	assert_str(str(data.obj_int)).is_equal("2")  # still this weird error when comparing integers/floats
	assert_str(data.obj_str).is_equal("test")
	assert_object(data.obj_color).is_equal(Color("#aaaaaa"))
	assert_str(data.obj_arr[0]).is_equal("test")
	assert_str(str(data.obj_arr[1])).is_equal("1")
	assert_object(data.obj_arr[2]).is_equal(Color("#ffffff"))
	assert_bool(data.obj_dict.obj_bool).is_true()
	assert_str(str(data.obj_dict.obj_int)).is_equal("2")
	assert_str(data.obj_dict.obj_str).is_equal("test")
	assert_object(data.obj_dict.obj_color).is_equal(Color("#aaaaaa"))
	assert_str(data.obj_dict.obj_arr[0]).is_equal("test")
	assert_str(str(data.obj_dict.obj_arr[1])).is_equal("1")
	assert_object(data.obj_dict.obj_arr[2]).is_equal(Color("#ffffff"))
	assert_bool(data.obj_dict.obj_recur.obj_bool).is_true()


func test_create_filter_auto_effect() -> void:
	var fade_time := 0.5
	var obj = FunctionUtils.create_filter_auto_effect(fade_time)
	assert_object(obj).is_instanceof(HalfFilterEffectManager)
	assert_float(obj.TIME).is_equal(fade_time)
	obj.free()


func test_is_player() -> void:
	var obj1 := KinematicBody.new()
	obj1.add_to_group("player")
	assert_bool(FunctionUtils.is_player(obj1)).is_true()
	var obj2 := KinematicBody.new()
	obj2.add_to_group("not player")
	assert_bool(FunctionUtils.is_player(obj2)).is_false()
	obj1.free()
	obj2.free()


func test_is_rocket() -> void:
	var obj1 := Area.new()
	obj1.add_to_group("rocket")
	assert_bool(FunctionUtils.is_rocket(obj1)).is_true()
	var obj2 := Area.new()
	obj2.add_to_group("not rocket")
	assert_bool(FunctionUtils.is_rocket(obj2)).is_false()
	obj1.free()
	obj2.free()


func test_is_start_point() -> void:
	var obj1 := Area.new()
	obj1.add_to_group("start_point")
	assert_bool(FunctionUtils.is_start_point(obj1)).is_true()
	var obj2 := Area.new()
	obj2.add_to_group("not start_point")
	assert_bool(FunctionUtils.is_start_point(obj2)).is_false()
	obj1.free()
	obj2.free()


func test_is_laser() -> void:
	var obj1 := Area.new()
	obj1.add_to_group("laser")
	assert_bool(FunctionUtils.is_laser(obj1)).is_true()
	var obj2 := Area.new()
	obj2.add_to_group("not laser")
	assert_bool(FunctionUtils.is_laser(obj2)).is_false()
	obj1.free()
	obj2.free()
