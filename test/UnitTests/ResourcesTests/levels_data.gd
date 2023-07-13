# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GdUnitTestSuite
# tests the LevelsData resource

##### VARIABLES #####

##### TESTS #####
#---- TESTS -----
#==== ACTUAL TESTS =====
func test_has_next_level() -> void:
	var levels = LevelsData.new()
	levels.LEVELS = [LevelData.new(),LevelData.new()]
	assert_bool(levels.has_next_level(0)).is_true()
	assert_bool(levels.has_next_level(1)).is_false()

func test_has_previous_level() -> void:
	var levels = LevelsData.new()
	levels.LEVELS = [LevelData.new(),LevelData.new()]
	assert_bool(levels.has_previous_level(1)).is_true()
	assert_bool(levels.has_previous_level(0)).is_false()

func test_check_has_level() -> void:
	var levels = LevelsData.new()
	assert_bool(levels.check_has_level(0)).is_false()
	levels.LEVELS = []
	assert_bool(levels.check_has_level(0)).is_false()
	levels.LEVELS = [Control.new()]
	assert_bool(levels.check_has_level(0)).is_false()
	levels.LEVELS = [LevelData.new()]
	assert_bool(levels.check_has_level(-1)).is_false()
	assert_bool(levels.check_has_level(1)).is_false()
	assert_bool(levels.check_has_level(0)).is_true()

func test_get_level() -> void:
	var levels = LevelsData.new()
	var level = LevelData.new()
	levels.LEVELS = [level]
	assert_object(levels.get_level(-1)).is_null()
	assert_object(levels.get_level(0)).is_equal(level)
