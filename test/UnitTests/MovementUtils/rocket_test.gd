# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the rocket

##### VARIABLES #####
const rocket_path := "res://Game/Common/MovementUtils/Rocket/rocket.tscn"
var rocket


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rocket_path
	.before()
	rocket = load(rocket_path).instance()
	rocket._ready()


func after():
	rocket.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
# TODO : for some reason, the export variables are not updated
# func test_init_rocket() -> void:
# 	var temp_spatial := Spatial.new()
# 	temp_spatial.transform.origin = Vector3.ONE
# 	temp_spatial.look_at(Vector3.ONE - Vector3.FORWARD, Vector3.UP)
# 	# standard case
# 	rocket.START_POS = Vector3.ONE
# 	rocket.DIRECTION = Vector3.FORWARD
# 	rocket._init_rocket()
# 	assert_vector3(rocket.transform.origin).is_equal(Vector3.ZERO)
# 	assert_vector3(rocket.rotation).is_equal(temp_spatial.rotation)
# 	# reset
# 	rocket.rotation = Vector3.ZERO
# 	# rocket going straight up
# 	rocket.START_POS = Vector3.ZERO
# 	rocket.DIRECTION = Vector3.UP
# 	assert_vector3(rocket.transform.origin).is_equal(Vector3.ZERO)
# 	assert_vector3(rocket.rotation).is_equal(Vector3.UP)
# 	# reset
# 	rocket.rotation = Vector3.ZERO
# 	# rocket going straight up
# 	rocket.START_POS = Vector3.ZERO
# 	rocket.DIRECTION = -Vector3.UP
# 	assert_vector3(rocket.transform.origin).is_equal(Vector3.ZERO)
# 	assert_vector3(rocket.rotation).is_equal(-Vector3.UP)
# 	temp_spatial.free()


func test_play_rocket_sound() -> void:
	rocket._play_rocket_sound()
	assert_bool(rocket.onready_paths.trail_sound.playing).is_true()


# Kind of redundant to test _check_raycast_distance


func test_get_distance_to_collision() -> void:
	var rc = mock(RayCast) as RayCast
	var not_player := StaticBody.new()
	do_return(true).on(rc).is_colliding()
	do_return(not_player).on(rc).get_collider()
	do_return(Vector3.FORWARD).on(rc).get_collision_point()
	do_return(-Vector3.FORWARD).on(rc).get_collision_normal()
	assert_float(rocket._get_distance_to_collision(rc)).is_equal(1.0)
	not_player.free()

# TODO : Cannot test _plan_explosion, _explode and _on_Rocket_body_entered because of get_tree
