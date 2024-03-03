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
	assert_vector3(laser.onready_paths.cube_mesh.scale).is_equal(Vector3.ONE * thickness * laser.CUBE_MESH_SCALE_MULTIPLIER)
	assert_vector3(laser.onready_paths.particles.process_material.emission_box_extents).is_equal(Vector3(thickness / laser.PARTICLES_EMISSION_BOX_DIVIDER.x, thickness / laser.PARTICLES_EMISSION_BOX_DIVIDER.y, laser.PARTICLES_EMISSION_BOX_HEIGHT))
	assert_vector3(laser.rotation_degrees).is_equal(mangle)	
	assert_float(laser.onready_paths.collision.translation.z).is_equal_approx(
		length / 2.0, FLOAT_APPROX
	)
	assert_float(laser.onready_paths.mesh.translation.z).is_equal_approx(length / 2.0, FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.translation.z).is_equal_approx(length, FLOAT_APPROX)


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
	assert_float(laser._last_length).is_equal_approx(new_length,FLOAT_APPROX)
	assert_float(laser.onready_paths.particles.translation.z).is_equal_approx(new_length, FLOAT_APPROX)

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
	assert_bool(RuntimeUtils.paths.death_sound.is_playing()).is_true()
	player.free()
	not_player.free()
