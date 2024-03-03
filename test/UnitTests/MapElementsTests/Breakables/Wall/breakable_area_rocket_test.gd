# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the breakable area rocket

##### VARIABLES #####
const breakable_area_path := "res://test/UnitTests/MapElementsTests/Breakables/Wall/breakable_area_speed_mock.tscn"
var breakable_area: Collidable


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = breakable_area_path
	.before()
	breakable_area = load(breakable_area_path).instance()


func after():
	breakable_area.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_add_sprite_ui() -> void:
	breakable_area._mangle = Vector3.ONE
	breakable_area._sprite_scale = Vector3.ONE
	breakable_area._add_ui_sprite()
	var sprite
	var ui
	for child in breakable_area.get_children():
		if child is Sprite3D:
			sprite = child
		if child is Viewport:
			ui = child
	assert_object(sprite).is_not_null()
	assert_object(ui).is_not_null()
	assert_vector3(sprite.rotation_degrees).is_equal(Vector3.ONE)
	assert_vector3(sprite.scale).is_equal(Vector3.ONE)
	sprite.free()
	ui.free()


func test_connect_signals() -> void:
	breakable_area._connect_signals()
	assert_bool(breakable_area.is_connected("body_entered", breakable_area, "_on_breakable_area_speed_body_entered")).is_true()