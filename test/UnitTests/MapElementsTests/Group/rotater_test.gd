# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests for a rotater

##### VARIABLES #####
const rotater_path := "res://test/UnitTests/MapElementsTests/Group/rotater_mock.tscn"
var rotater


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rotater_path
	.before()
	rotater = load(rotater_path).instance()
	rotater._ready()


func after():
	rotater.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_rotate_spatial() -> void:
	var delta = 1.0
	var rotation_speed = Vector3(3, 2, 1)
	rotater._rotation_speed = rotation_speed
	rotater._rotate_spatial(delta)
	assert_vector3(rotater.rotation).is_equal(rotation_speed * delta)
