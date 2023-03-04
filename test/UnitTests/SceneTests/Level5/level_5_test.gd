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
# tests if the song name and animation are correct for tutorial 1
# func test_song() -> void:
# 	assert_str(scene_instance.PATHS.bgm.path).is_equal("res://Game/Common/Songs/Tutorial3/tutorial_3.tscn")
# 	assert_str(scene_instance.PATHS.bgm.animation).is_equal("part_1")


# tests if the player abilities are correct for tutorial 1
func test_start_player_abilities() -> void:
	assert_bool(scene_instance.ENABLE_ROCKETS).is_true()
	assert_bool(scene_instance.ENABLE_SLIDE).is_true()
