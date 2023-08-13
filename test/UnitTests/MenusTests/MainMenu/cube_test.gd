# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the cube from the main menu

##### VARIABLES #####
const cube_path := "res://Game/Common/Menus/MainMenu/cube.tscn"
var cube


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = cube_path
	.before()
	cube = load(cube_path).instance()
	cube._ready()

func after():
	cube.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_get_border_material() -> void:
	assert_object(cube.get_border_material()).is_not_null()

func test_get_face_gradient() -> void:
	assert_object(cube.get_face_gradient()).is_not_null()

func test_update_gradient() -> void:
	var original_colors = [cube.get_face_gradient().gradient.get_color(0),cube.get_face_gradient().gradient.get_color(1)] # to set back to the original colors after the test
	var test_col := Color(1,2,3,1)
	# test update the color 1
	cube.update_gradient_1(test_col)
	assert_object(cube.get_face_gradient().gradient.get_color(0)).is_equal(test_col)
	# test update the color 1
	cube.update_gradient_2(test_col)
	assert_object(cube.get_face_gradient().gradient.get_color(1)).is_equal(test_col)
	# sets back the colors
	cube.update_gradient_1(original_colors[0])
	cube.update_gradient_2(original_colors[1])
 
# not really necessary to test _get_face_material and _get_gradient, because of test_get_face_gradient
