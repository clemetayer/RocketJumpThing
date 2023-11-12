# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# description

##### VARIABLES #####
const common_slider_path := "res://test/UnitTests/UtilsTests/UI/common_slider_test_mock.tscn"
var common_slider


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = common_slider_path
	.before()
	common_slider = load(common_slider_path).instance()

func after():
	common_slider.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_on_slider_changed() -> void:
	common_slider._on_slider_changed(0.1)
	assert_bool(RuntimeUtils.paths.slider_moved.is_playing()).is_true()
