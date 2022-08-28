# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends StandardSceneTest
# description

##### VARIABLES #####


##### TESTS #####
#---- PRE/POST -----
func before():
	scene_path = "res://Game/Scenes/Tutorial/Scene2/Scene2.tscn"
	.before()


#---- TESTS -----
#==== ACTUAL TESTS =====
# tests if the song name and animation are correct for tutorial 1
func test_song() -> void:
	assert_str(scene_instance.PATHS.bgm.path).is_equal("res://Game/Common/Songs/Tutorial1.tscn")
	assert_str(scene_instance.PATHS.bgm.animation).is_equal("part1")


# tests if the player abilities are correct for tutorial 1
func test_start_player_abilities() -> void:
	assert_bool(scene_instance.ENABLE_ROCKETS).is_false()
	assert_bool(scene_instance.ENABLE_SLIDE).is_false()
