# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends StandardSceneTest
# tests for the level 5


##### TESTS #####
#---- PRE/POST -----
func before():
	scene_path = "res://Game/Scenes/Levels/Level5/level_5.tscn"
	.before()


#---- TESTS -----
#==== ACTUAL TESTS =====
# tests if the player abilities are correct for tutorial 1
func test_start_player_abilities() -> void:
	assert_bool(scene_instance.ENABLE_ROCKETS).is_true()
	assert_bool(scene_instance.ENABLE_SLIDE).is_true()

# end area in scene
func test_end_in_scene() -> void:
	assert_int(GlobalTestUtilities.count_in_group_in_children(scene_instance, "end_point", true)).is_equal(
		1
	)