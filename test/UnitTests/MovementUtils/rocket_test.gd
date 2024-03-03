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
