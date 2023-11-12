# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# description

##### VARIABLES #####
const common_button_path := "res://test/UnitTests/UtilsTests/UI/common_button_test_mock.tscn"
var common_button


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = common_button_path
	.before()
	common_button = load(common_button_path).instance()

func after():
	common_button.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_on_button_pressed() -> void:
	common_button._on_button_pressed()
	assert_bool(RuntimeUtils.paths.button_clicked.is_playing()).is_true()

func test_on_button_hover() -> void:
	common_button._on_button_hover()
	assert_bool(RuntimeUtils.paths.button_hover.is_playing()).is_true()
