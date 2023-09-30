# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the double rocket indicator ui

##### VARIABLES #####
const DRI_ui_path := "res://Game/Common/MapElements/DoubleRocketIndicator/double_rocket_indicator_ui.tscn"
var DRI_ui


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = DRI_ui_path
	.before()
	DRI_ui = load(DRI_ui_path).instance()
	DRI_ui._ready()

func after():
	DRI_ui.free()
	.after()

func after_test():
	pass

#---- TESTS -----
func test_init_hbox() -> void:
	DRI_ui.COLOR = Color.aqua
	DRI_ui._init_hbox()
	assert_vector2(DRI_ui.size).is_equal(DRI_ui.onready_paths.hbox.rect_size)
	assert_str(str(DRI_ui.onready_paths.hbox.modulate)).is_equal(str(Color.aqua))
