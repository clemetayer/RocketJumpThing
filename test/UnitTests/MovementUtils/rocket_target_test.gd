# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the rocket hit target

##### VARIABLES #####
const FLOAT_APPROX := 0.01
const rocket_target_path := "res://Game/Common/MovementUtils/Rocket/rocket_target.tscn"
var rocket_target


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rocket_target_path
	.before()
	rocket_target = load(rocket_target_path).instance()


func after():
	rocket_target.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_set_pos() -> void:
	var hit_pos = Vector3.ONE
	var normal = Vector3.LEFT
	rocket_target.set_pos(hit_pos, normal)
	# assert_vector3(rocket_target.global_transform.origin).is_equal(hit_pos) # won't update in test mode
	assert_float(rocket_target.rotation.x).is_equal_approx(PI / 4, FLOAT_APPROX)
	assert_float(rocket_target.rotation.y).is_equal_approx(PI, FLOAT_APPROX)


func test_update_scale() -> void:
	rocket_target.update_scale(rocket_target.MAX_DIST + 1.0)
	assert_float(rocket_target.modulate.a).is_equal(0.0)
	var dist = rocket_target.MAX_DIST - 1.0
	var scale = (dist / rocket_target.MAX_DIST) * rocket_target.MAX_SCALE
	rocket_target.update_scale(dist)
	assert_float(rocket_target.modulate.a).is_equal(1.0)
	assert_vector3(rocket_target.scale).is_equal(Vector3(scale, scale, 1))
