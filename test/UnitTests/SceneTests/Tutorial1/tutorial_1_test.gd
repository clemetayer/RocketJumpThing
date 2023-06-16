# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends StandardSceneTest
# description

##### VARIABLES #####


##### TESTS #####
#---- PRE/POST -----
func before():
	scene_path = "res://Game/Scenes/Tutorial/Tutorial1/tutorial_1.tscn"
	.before()


#---- TESTS -----
#==== ACTUAL TESTS =====
# tests if the song name and animation are correct for tutorial 1
func test_song() -> void:
	assert_str(scene_instance.PATHS.bgm.path).is_equal("res://Game/Common/Songs/Tutorial1/tutorial_1.tscn")
	assert_str(scene_instance.PATHS.bgm.animation).is_equal("part1")


# tests if the player abilities are correct for tutorial 1
func test_start_player_abilities() -> void:
	assert_bool(scene_instance.ENABLE_ROCKETS).is_false()
	assert_bool(scene_instance.ENABLE_SLIDE).is_false()

# end area in scene
func test_end_in_scene() -> void:
	assert_int(GlobalTestUtilities.count_in_group_in_children(scene_instance, "end_point", true)).is_equal(
		1
	)