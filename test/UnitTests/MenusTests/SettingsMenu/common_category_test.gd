# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the settings common category

##### VARIABLES #####
const common_category_path := "res://Game/Common/Menus/SettingsMenu/common_category.tscn"
var common_category


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = common_category_path
	.before()
	common_category = load(common_category_path).instance()
	common_category._ready()


func after():
	.after()
	common_category.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_set_category_name() -> void:
	var TEST_CATEGORY := "test"
	common_category.CATEGORY_NAME = TEST_CATEGORY
	common_category.set_category_name(TEST_CATEGORY)
	assert_str(common_category.onready_paths.separator_label.text).is_equal(TEST_CATEGORY)
