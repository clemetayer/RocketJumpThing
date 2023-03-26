# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name PeriodicMovingSpatialTest
# Global tests for the periodic moving spatial

##### VARIABLES #####
var periodic_moving_spatial_path := ""
var periodic_moving_spatial: Spatial


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = periodic_moving_spatial_path
	.before()
	periodic_moving_spatial = load(element_path).instance()
	periodic_moving_spatial._ready()


func after():
	periodic_moving_spatial.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
# TODO : Complex to test, the tween and timer does not operate well together in the runner
# func test_run_movement() -> void:
# 	var runner := scene_runner(moving_platform_path)
# 	runner.invoke(
# 		"set_properties",
# 		{
# 			"point1": Vector3(0, 0, 1),
# 			"point2": Vector3(0, 1, 1),
# 			"point3": Vector3(1, 1, 1),
# 			"travel_time": 1,
# 			"wait_time": 0.5,
# 		}
# 	)
# 	runner.invoke("_set_translation", Vector3.ONE)
# 	runner.invoke("_ready")
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3.ONE)
# 	yield(runner.simulate_frames(120, 1000 / 120), "completed")  # 60 frames at 60 fps (1s) # Complete one step loop because calling _ready one more time on runner adds another origin point
# 	yield(runner.simulate_frames(120, 1000 / 120), "completed")  # 60 frames at 60 fps (1s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(1, 1, 2))
# 	yield(runner.simulate_frames(60, 1000 / 120), "completed")  # 30 frames at 60 fps (0.5s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(1, 1, 2))
# 	yield(runner.simulate_frames(120, 1000 / 120), "completed")  # 60 frames at 60 fps (1s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(1, 2, 2))
# 	yield(runner.simulate_frames(60, 1000 / 120), "completed")  # 30 frames at 60 fps (0.5s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(1, 2, 2))
# 	yield(runner.simulate_frames(120, 1000 / 120), "completed")  # 60 frames at 60 fps (1s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(2, 2, 2))
# 	yield(runner.simulate_frames(60, 1000 / 120), "completed")  # 30 frames at 60 fps (0.5s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(2, 2, 2))
# 	yield(runner.simulate_frames(120, 1000 / 120), "completed")  # 60 frames at 60 fps (1s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(1, 1, 1))
# 	yield(runner.simulate_frames(60, 1000 / 120), "completed")  # 30 frames at 60 fps (0.5s)
# 	assert_vector3(runner.get_property("translation")).is_equal(Vector3(1, 1, 1))


func test_create_show_path_mesh() -> void:
	var mock_mesh := MeshInstance.new()
	mock_mesh.mesh = CapsuleMesh.new()
	mock_mesh.mesh.radius = periodic_moving_spatial.PATH_MESH_RADIUS
	mock_mesh.mesh.mid_height = Vector3.ZERO.distance_to(Vector3.ONE)
	mock_mesh.look_at(Vector3.ONE, Vector3.UP)
	var test_mesh = periodic_moving_spatial._create_show_path_mesh(Vector3.ZERO, Vector3.ONE)
	assert_float(test_mesh.mesh.radius).is_equal(mock_mesh.mesh.radius)
	assert_float(test_mesh.mesh.mid_height).is_equal(mock_mesh.mesh.mid_height)
	assert_vector3(test_mesh.rotation).is_equal(mock_mesh.rotation)
	mock_mesh.free()
	test_mesh.free()