# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the death grid material

##### VARIABLES #####
const death_grid_material_path := "res://test/UnitTests/MapElementsTests/DeathGrid/death_grid_material_mock.tscn"
var death_grid_material


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = death_grid_material_path
	.before()
	death_grid_material = load(death_grid_material_path).instance()


func after():
	death_grid_material.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_update_size() -> void:
	death_grid_material.mesh.size = Vector3.ONE * 2
	death_grid_material._update_size()
	assert_vector3(death_grid_material.mesh.surface_get_material(0).get_shader_param("size")).is_equal(
		Vector3.ONE * 2
	)

# TODO : complex to test because of the add_child
# func test_update_position() -> void:
# 	var player := Player.new()
# 	player.get_global_transform().origin = Vector3.ONE
# 	death_grid_material.add_child(player)
# 	death_grid_material.target = death_grid_material.get_path_to(player)
# 	death_grid_material._update_position()
# 	assert_vector3(death_grid_material.mesh.surface_get_material(0).get_shader_param("target_pos")).is_equal(
# 		Vector3.ONE
# 	)
# 	player.free()
