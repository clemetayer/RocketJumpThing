# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the tutorial hints

##### VARIABLES #####
const DIRECTION_SCENE_NAME := "WASDElement"
const SINGLE_KEY_SCENE_NAME := "SingleKey"
const MOUSE_SCENE_NAME := "Mouse"
const BOOST_PAD_SCENE_NAME := "BoostPad"
const tutorial_hints_path := "res://Game/Common/MapElements/Characters/tutorial_hints.tscn"
var tutorial_hints: CanvasLayer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = tutorial_hints_path
	.before()
	tutorial_hints = load(tutorial_hints_path).instance()


func after():
	tutorial_hints.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_call_replace_method() -> void:
	var tutorial_hints_mock = mock(tutorial_hints_path)
	# movement_wasd
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_WASD)
	verify(tutorial_hints_mock, 1)._replace_move_direction(true, true, true, true)
	# movement_wa
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_WA)
	verify(tutorial_hints_mock, 1)._replace_move_direction(true, false, true, false)
	# movement_wd
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_WD)
	verify(tutorial_hints_mock, 1)._replace_move_direction(true, false, false, true)
	# movement_w
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_W)
	verify(tutorial_hints_mock, 1)._replace_move_direction(true, false, false, true)
	# movement_jump
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_JUMP)
	verify(tutorial_hints_mock, 1)._replace_jump()
	# movement_slide
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_SLIDE)
	verify(tutorial_hints_mock, 1)._replace_slide()
	# mouse_strafe_left
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MOUSE_STRAFE_LEFT)
	verify(tutorial_hints_mock, 1)._replace_strafe(false, false, true, false)
	# mouse_strafe_right
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_MOUSE_STRAFE_RIGHT)
	verify(tutorial_hints_mock, 1)._replace_strafe(false, false, false, true)
	# mouse_strafe_left_right
	tutorial_hints_mock._call_replace_method(
		GlobalConstants.TR_REPLACE_TUTORIAL_MOUSE_STRAFE_LEFT_RIGHT
	)
	verify(tutorial_hints_mock, 1)._replace_strafe(false, false, true, true)
	# restart
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_RESTART)
	verify(tutorial_hints_mock, 1)._replace_restart()
	# restart_last_cp
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_RESTART_LAST_CP)
	verify(tutorial_hints_mock, 1)._replace_restart_last_cp()
	# shoot
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_ACTION_SHOOT)
	verify(tutorial_hints_mock, 1)._replace_shoot()
	# rocket_icon
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_ROCKET_ICON)
	verify(tutorial_hints_mock, 1)._replace_rocket_icon()
	# rocket_jump_icon
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_ROCKET_JUMP_ICON)
	verify(tutorial_hints_mock, 1)._replace_rocket_jump_icon()
	# boost_pad
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_BOOST_PAD)
	verify(tutorial_hints_mock, 1)._replace_boost_pad(false)
	# boost_pad_enhanced
	tutorial_hints_mock._call_replace_method(GlobalConstants.TR_REPLACE_TUTORIAL_BOOST_PAD_ENHANCED)
	verify(tutorial_hints_mock, 1)._replace_boost_pad(true)


func test_no_input() -> void:
	var non_existant_str := "NON_EXISTANT_STRING"
	var control = tutorial_hints._call_replace_method(non_existant_str)
	assert_object(control).is_instanceof(Label)
	assert_str(control.text).is_equal(non_existant_str)


func test_replace_move_direction() -> void:
	var control = tutorial_hints._replace_move_direction(true, true, true, true)
	assert_str(control.name).is_equal(DIRECTION_SCENE_NAME)
# FIXME : onready_paths has issues with tests
#	assert_bool(control.onready_paths.forward.pressed).is_true()
#	assert_bool(control.onready_paths.backward.pressed).is_true()
#	assert_bool(control.onready_paths.left.pressed).is_true()
#	assert_bool(control.onready_paths.right.pressed).is_true()
	control = tutorial_hints._replace_move_direction(false, false, false, false)
	assert_str(control.name).is_equal(DIRECTION_SCENE_NAME)


#	assert_bool(control.onready_paths.forward.pressed).is_false()
#	assert_bool(control.onready_paths.backward.pressed).is_false()
#	assert_bool(control.onready_paths.left.pressed).is_false()
#	assert_bool(control.onready_paths.right.pressed).is_false()


func test_handle_keyboard_input() -> void:
	var input = InputEventKey.new()
	# Test one letter inputs
	input.scancode = KEY_W
	var control = tutorial_hints._handle_keyboard_input(input)
	assert_str(control.name).is_equal(SINGLE_KEY_SCENE_NAME)
	assert_str(control.key_text).is_equal("W")
	assert_bool(control.pressed).is_true()
	# Test multiple letters inputs
	input.scancode = KEY_SPACE
	control = tutorial_hints._handle_keyboard_input(input)
	assert_str(control.name).is_equal(SINGLE_KEY_SCENE_NAME)
	assert_str(control.key_text).is_equal("Space")
	assert_bool(control.pressed).is_true()


func test_handle_mouse_input() -> void:
	var input = InputEventMouseButton.new()
	# Test left click
	input.button_index = BUTTON_LEFT
	var control = tutorial_hints._handle_mouse_input(input)
	assert_str(control.name).is_equal(MOUSE_SCENE_NAME)
# FIXME : onready_paths has issues with tests
#	assert_bool(control.onready_paths.mouse.lclick.visible).is_true()
#	assert_bool(control.onready_paths.mouse.rclick.visible).is_false()
	# Test right click
	input.button_index = BUTTON_RIGHT
	control = tutorial_hints._handle_mouse_input(input)
	assert_str(control.name).is_equal(MOUSE_SCENE_NAME)


#	assert_bool(control.onready_paths.mouse.lclick.visible).is_false()
#	assert_bool(control.onready_paths.mouse.rclick.visible).is_true()


func test_handle_joypad_input() -> void:
	# Not yet implemented
	pass


func test_replace_strafe() -> void:
	# All arrows
	var control = tutorial_hints._replace_strafe(true, true, true, true)
	assert_str(control.name).is_equal(MOUSE_SCENE_NAME)
	# FIXME : onready_paths has issues with tests
#	assert_bool(control.onready_paths.up_arrow.visible).is_true()
#	assert_bool(control.onready_paths.down_arrow.visible).is_true()
#	assert_bool(control.onready_paths.left_arrow.visible).is_true()
#	assert_bool(control.onready_paths.right.visible).is_true()
	# No arrows
	control = tutorial_hints._replace_strafe(false, false, false, false)
	assert_str(control.name).is_equal(MOUSE_SCENE_NAME)


#	assert_bool(control.onready_paths.up_arrow.visible).is_false()
#	assert_bool(control.onready_paths.down_arrow.visible).is_false()
#	assert_bool(control.onready_paths.left_arrow.visible).is_false()
#	assert_bool(control.onready_paths.right.visible).is_false()

# FIXME : issues on tests with add_child
#func test_set_tutorial_text() -> void:
#	var tutorial_hints_mock = mock(tutorial_hints_path)
#	do_return(VBoxContainer.new()).on(tutorial_hints_mock)._call_replace_method("test1")
#	do_return(CenterContainer.new()).on(tutorial_hints_mock)._call_replace_method("test2")
#	do_return("Test string with ##test1## and\n##test2## as arguments").on(tutorial_hints_mock).tr(
#		"test"
#	)
#	assert_int(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child_count()).is_equal(
#		2
#	)
#	assert_int(
#		tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(0).get_child_count(
#			3
#		)
#	)
#	assert_int(
#		tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(1).get_child_count(
#			2
#		)
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(0)).is_instanceof(
#		HBoxContainer
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(1)).is_instanceof(
#		HBoxContainer
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(0).get_child(0)).is_instanceof(
#		Label
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(0).get_child(1)).is_instanceof(
#		VBoxContainer
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(0).get_child(2)).is_instanceof(
#		Label
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(1).get_child(0)).is_instanceof(
#		CenterContainer
#	)
#	assert_object(tutorial_hints_mock.get_node("Screen/CenterContainer/VBoxContainer").get_child(1).get_child(1)).is_instanceof(
#		Label
#	)


func test_create_texture_rect_from_path():
	assert_object(tutorial_hints._create_texture_rect_from_path("res://icon.png")).is_instanceof(
		TextureRect
	)
