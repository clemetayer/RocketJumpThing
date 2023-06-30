# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests for the laser

##### VARIABLES #####
const FLOAT_APPROX := 0.001  # a float approximation to make the tests work
const laser_path := "res://Game/Common/MapElements/Lasers/laser.tscn"
var laser


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = laser_path
	.before()
	laser = load(laser_path).instance()
	laser._ready()


func after():
	laser.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	laser._connect_signals()
	assert_bool(laser.is_connected("body_entered", laser, "_on_body_entered"))


func test_init_laser() -> void:
	var length := 10.5
	var thickness := 0.1
	var mangle := Vector3(10.0, 0.5, -10.0)
	laser._max_length = length
	laser._thickness = thickness
	laser._mangle = mangle
	laser._init_laser()
	assert_float(laser.onready_paths.collision.shape.height).is_equal_approx(length, FLOAT_APPROX)
	assert_float(laser.onready_paths.collision.shape.radius).is_equal_approx(
		thickness, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.mesh.mesh.height).is_equal_approx(length, FLOAT_APPROX)
	assert_float(laser.onready_paths.mesh.mesh.top_radius).is_equal_approx(thickness, FLOAT_APPROX)
	assert_float(laser.onready_paths.mesh.mesh.bottom_radius).is_equal_approx(
		thickness, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.raycast.cast_to.z).is_equal_approx(length, FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.transform.origin.z).is_equal_approx(length/2.0, FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.process_material.emission_ring_inner_radius).is_equal_approx(thickness, FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.process_material.emission_ring_radius).is_equal_approx(thickness + laser.PARTICLES_RING_OUTER_RADIUS_ADD, FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.process_material.emission_ring_height).is_equal_approx(length,FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.visibility_aabb.size.z).is_equal_approx(length,FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.visibility_aabb.position.z).is_equal_approx(-length/2.0,FLOAT_APPROX)
	assert_int(laser.onready_paths.particles.amount).is_equal(int(length * laser.PARTICLES_STD_AMOUNT))
	assert_vector3(laser.rotation_degrees).is_equal(mangle)	
	assert_float(laser.onready_paths.collision.translation.z).is_equal_approx(
		length / 2.0, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.mesh.translation.z).is_equal_approx(length / 2.0, FLOAT_APPROX)


func test_update_laser() -> void:
	# inits the laser with default values
	var max_length := 15.5
	var thickness := 0.1
	var mangle := Vector3(10.0, 0.5, -10.0)
	laser._max_length = max_length
	laser._thickness = thickness
	laser._mangle = mangle
	laser._init_laser()
	laser._last_length = 0.0
	# update
	var new_length := 5.0
	laser._update_laser(new_length)
	assert_float(laser.onready_paths.collision.shape.height).is_equal_approx(
		new_length, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.mesh.mesh.height).is_equal_approx(new_length, FLOAT_APPROX)
	assert_float(laser.onready_paths.collision.translation.z).is_equal_approx(
		new_length / 2.0, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.mesh.translation.z).is_equal_approx(
		new_length / 2.0, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.particles.transform.origin.z).is_equal_approx(new_length/2.0, FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.process_material.emission_ring_height).is_equal_approx(new_length,FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.visibility_aabb.size.z).is_equal_approx(new_length,FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.visibility_aabb.position.z).is_equal_approx(-new_length/2.0,FLOAT_APPROX)
	assert_int(laser.onready_paths.particles.amount).is_equal(int(new_length * laser.PARTICLES_STD_AMOUNT))
	assert_float(laser._last_length).is_equal_approx(new_length,FLOAT_APPROX)


# FIXME : Can't mock things for some reason
# func test_check_raycast() -> void:
# 	var max_length := 10.5
# 	var mid_length := 5.0
# 	var mock = mock(laser_path)
# 	mock._ready()
# 	do_return(null).on(mock)._update_laser(max_length)
# 	do_return(mid_length).on(mock.onready_paths.global_transform.origin).distance_to()
# 	do_return(null).on(mock)._update_laser(mid_length)
# 	# case colliding
# 	do_return(true).on(mock.onready_paths.raycast).is_colliding()
# 	mock._check_raycast()
# 	verify(mock, 1)._update_laser(max_length)
# 	verify(mock, 0)._update_laser(mid_length)
# 	# case not colliding
# 	## reset the mock
# 	mock = mock(laser_path)
# 	mock._ready()
# 	do_return(null).on(mock)._update_laser(max_length)
# 	do_return(mid_length).on(mock.onready_paths.global_transform.origin).distance_to()
# 	do_return(null).on(mock)._update_laser(mid_length)
# 	## test
# 	do_return(false).on(mock.onready_paths.raycast).is_colliding()
# 	mock._check_raycast()
# 	verify(mock, 0)._update_laser(max_length)
# 	verify(mock, 1)._update_laser(mid_length)


func test_on_body_entered() -> void:
	var player := KinematicBody.new()
	player.add_to_group("player")
	var not_player := KinematicBody.new()
	laser._on_body_entered(not_player)
	yield(
		assert_signal(SignalManager).is_not_emitted(SignalManager.RESPAWN_PLAYER_ON_LAST_CP),
		"completed"
	)
	laser._on_body_entered(player)
	yield(
		assert_signal(SignalManager).is_emitted(SignalManager.RESPAWN_PLAYER_ON_LAST_CP),
		"completed"
	)
	player.free()
	not_player.free()
