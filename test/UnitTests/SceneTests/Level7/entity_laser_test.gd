# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests for the entity's laser

##### VARIABLES #####
const FLOAT_APPROX := 0.01
const entity_laser_path := "res://Game/Scenes/Levels/Level7/TheEntity/entity_laser.tscn"
var entity_laser


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = entity_laser_path
	.before()
	entity_laser = load(entity_laser_path).instance()
	entity_laser._ready()


func after():
	entity_laser.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_fire() -> void:
	entity_laser.fire()
	assert_str(entity_laser.onready_paths.animation_player.current_animation).is_equal(entity_laser.FIRE_ANIM_NAME)
	assert_bool(entity_laser.onready_paths.animation_player.is_playing()).is_true()
	entity_laser.onready_paths.animation_player.stop()


# also tests _update_laser_length and _update_target
func test_update_laser_length() -> void:
	entity_laser.mock = true
	entity_laser.mock_position = Vector3(5.0,3.0,0.0)
	var dist = (entity_laser.global_transform.origin + entity_laser.LASER_OFFSET).distance_to(entity_laser.mock_position)
	entity_laser._update_laser_length()
	# Tests the laser mesh
	assert_float(entity_laser.onready_paths.laser_mesh.mesh.height).is_equal(dist)
	assert_vector3(entity_laser.onready_paths.laser_mesh.transform.origin).is_equal(entity_laser.LASER_OFFSET - Vector3(0,0,dist/2.0))
	# Tests the laser collision shape
	assert_float(entity_laser.onready_paths.laser_shape.shape.height).is_equal(dist)
	assert_vector3(entity_laser.onready_paths.laser_shape.transform.origin).is_equal(entity_laser.LASER_OFFSET - Vector3(0,0,dist/2.0))
	# Tests the fire particles
	## Fire particles 1
	assert_vector3(entity_laser.onready_paths.fire_particles_1.transform.origin).is_equal(entity_laser.LASER_OFFSET - Vector3(0,0,dist/2.0))
	assert_float(entity_laser.onready_paths.fire_particles_1.visibility_aabb.size.z).is_equal(dist)
	assert_float(entity_laser.onready_paths.fire_particles_1.visibility_aabb.position.z).is_equal(-dist/2.0)
	assert_float(entity_laser.onready_paths.fire_particles_1.process_material.emission_box_extents.z).is_equal(dist/2.0)
	assert_int(entity_laser.onready_paths.fire_particles_1.amount).is_equal(int(dist * entity_laser.FIRE_PARTICLES_1_AMOUNT))
	## Fire particles 2
	assert_float(entity_laser.onready_paths.fire_particles_1.visibility_aabb.size.z).is_equal(dist)
	assert_float(entity_laser.onready_paths.fire_particles_1.visibility_aabb.position.z).is_equal(-dist/2.0)
	assert_float(entity_laser.onready_paths.fire_particles_2.lifetime).is_equal_approx((dist/entity_laser.onready_paths.fire_particles_2.process_material.initial_velocity),FLOAT_APPROX)
	