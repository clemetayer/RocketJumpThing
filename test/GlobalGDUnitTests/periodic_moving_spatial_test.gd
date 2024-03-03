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
