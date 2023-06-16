# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends StandardSceneTest
# tests for the level 7


##### TESTS #####
#---- PRE/POST -----
func before():
	scene_path = "res://Game/Scenes/Levels/Level7/level_7.tscn"
	.before()


#---- TESTS -----
#==== ACTUAL TESTS =====
# tests if the player abilities are correct for tutorial 1
func test_start_player_abilities() -> void:
	assert_bool(scene_instance.ENABLE_ROCKETS).is_true()
	assert_bool(scene_instance.ENABLE_SLIDE).is_true()
