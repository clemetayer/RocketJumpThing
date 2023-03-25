# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name VerticalBoostTest
# global tests for the vertical boost area

##### VARIABLES #####
var vertical_boost_path := ""
var vertical_boost: Area


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = vertical_boost_path
	.before()
	vertical_boost = load(element_path).instance()
	vertical_boost._ready()


func after():
	vertical_boost.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_ready_func() -> void:
	vertical_boost._mangle = Vector3.ONE
	vertical_boost._ready_func()
	assert_vector3(vertical_boost.rotation_degrees).is_equal(Vector3.ONE + Vector3(90,0,0))


func test_connect_signals() -> void:
	vertical_boost._connect_signals()
	assert_bool(vertical_boost.is_connected("body_entered", vertical_boost, "_on_body_entered")).is_true()
	assert_bool(vertical_boost.is_connected("area_entered", vertical_boost, "_on_area_entered")).is_true()


func test_set_extents() -> void:
	vertical_boost._size = Vector3.ONE * 2
	vertical_boost._set_extents()
	assert_vector3(vertical_boost.onready_paths.collision.shape.extents).is_equal(Vector3.ONE * 2)


func test_on_body_entered() -> void:
	var player = load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	vertical_boost._force = 10
	vertical_boost._boost_multiplier = 2
	vertical_boost._on_body_entered(player)
	assert_vector3(player._override_velocity_vector).is_equal(Vector3.UP * 10 * 2)
	player.free()
