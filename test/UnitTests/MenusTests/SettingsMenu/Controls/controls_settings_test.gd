# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the controls settings menu

##### VARIABLES #####
const controls_path := "res://Game/Common/Menus/SettingsMenu/Controls/controls_settings.tscn"
var controls


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = controls_path
	.before()
	controls = load(controls_path).instance()
	controls._ready()


func after():
	.after()
	controls.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_add_key_settings_to_groups() -> void:
	controls._add_key_settings_to_groups()
	assert_int(controls.onready_paths.movement.get_children().size()).is_equal(
		controls.MOVEMENT_CAT.size()
	)
	assert_int(controls.onready_paths.action.get_children().size()).is_equal(
		controls.ACTION_CAT.size()
	)
	assert_int(controls.onready_paths.ui.get_children().size()).is_equal(controls.UI_CAT.size())


func test_init_editable_key() -> void:
	var ret = controls._init_editable_key(GlobalTestUtilities.TEST_ACTION)
	assert_object(ret).is_instanceof(CommonEditableKey)
	assert_str(ret.ACTION_NAME).is_equal(GlobalTestUtilities.TEST_ACTION)
	ret.free()


func test_free_categories() -> void:
	# init
	controls.onready_paths.movement.add_child(Control.new())
	controls.onready_paths.action.add_child(Control.new())
	controls.onready_paths.ui.add_child(Control.new())
	# test
	controls._free_categories()
	assert_int(controls.onready_paths.movement.get_children().size()).is_equal(0)
	assert_int(controls.onready_paths.action.get_children().size()).is_equal(0)
	assert_int(controls.onready_paths.ui.get_children().size()).is_equal(0)
