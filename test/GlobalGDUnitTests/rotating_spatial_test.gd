# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name RotatingSpatialTest
# Global tests for the rotating spatial

##### VARIABLES #####
var rotating_spatial_path := ""
var rotating_spatial: Spatial


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rotating_spatial_path
	.before()
	rotating_spatial = load(element_path).instance()
	rotating_spatial._ready()


func after():
	rotating_spatial.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_rotate_spatial() -> void:
	var rotate_speed = Vector3(1.0, 1.5, 2.0)
	var delta = 1.5
	rotating_spatial.rotation = Vector3.ZERO
	rotating_spatial._rotation_speed = rotate_speed
	rotating_spatial._rotate_spatial(delta)
	assert_vector3(rotating_spatial.rotation).is_equal(rotate_speed * delta)
