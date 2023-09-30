# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the double rocket indicator

##### VARIABLES #####
const DRI_path := "res://test/UnitTests/MapElementsTests/DoubleRocketIndicator/double_rocket_indicator_mock.tscn"
var DRI


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = DRI_path
	.before()
	DRI = load(DRI_path).instance()
	DRI._ready()

func after():
	DRI.free()
	.after()

func after_test():
	pass

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_add_sprite_ui() -> void:
	DRI._mangle = Vector3.ONE
	DRI._sprite_scale = Vector3.ONE
	DRI._color = Color.aqua
	DRI._add_ui_sprite()
	var sprite
	var ui
	for child in DRI.get_children():
		if child is Sprite3D:
			sprite = child
		if child is Viewport:
			ui = child
	assert_object(sprite).is_not_null()
	assert_object(ui).is_not_null()
	assert_vector3(sprite.rotation_degrees).is_equal(Vector3.ONE)
	assert_vector3(sprite.scale).is_equal(Vector3.ONE)
	assert_str(str(ui.COLOR)).is_equal(str(Color.aqua))
	sprite.free()
	ui.free()