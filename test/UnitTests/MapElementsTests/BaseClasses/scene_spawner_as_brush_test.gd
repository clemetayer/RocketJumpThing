# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Test for the scene spawner as brush

##### VARIABLES #####
const scene_spawner_path := "res://test/UnitTests/MapElementsTests/BaseClasses/scene_spawner_as_brush_mock.tscn"
var scene_spawner


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = scene_spawner_path
	.before()
	scene_spawner = load(scene_spawner_path).instance()


func after():
	scene_spawner.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_spawn_scene() -> void:
	scene_spawner._scene_path = scene_spawner_path
	scene_spawner._spawn_scene()
	assert_int(scene_spawner.get_child_count()).is_equal(1)
	for child in scene_spawner.get_children():
		child.free()
