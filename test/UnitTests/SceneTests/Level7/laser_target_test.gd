# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests for the laser target

##### VARIABLES #####
const laser_target_path := "res://test/UnitTests/SceneTests/Level7/laser_target_mock.tscn"
var laser_target


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = laser_target_path
	.before()
	laser_target = load(laser_target_path).instance()


func after():
	laser_target.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_set_pos() -> void:
	var hit_pos := Vector3(5.0,0.0,0.0)
	var normal := Vector3.RIGHT
	laser_target.set_pos(hit_pos,normal)
	# assert_vector3(laser_target.global_transform.origin).is_equal(hit_pos) # global transform not changed ?
	assert_vector3(laser_target.rotation).is_equal(Vector3(0.0,-PI/2.0,0.0))
