# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GdUnitTestSuite
class_name GlobalTests
# Global tests for ALL scenes. Mostly to check that it is at least not crashing
# TODO : find a way to test with Autoload objects

##### VARIABLES #####
var element_path: String  # Element to test
var element_instance: Object  # instance of the element
var global_utilities: GlobalTestUtilities


##### TESTS #####
#---- PRE/POST -----
func before():
	if element_instance == null:
		element_instance = load(element_path).instance()
	global_utilities = GlobalTestUtilities.new()


func after():
	element_instance.free()
	global_utilities.free()


#---- TESTS -----
# test description
func test_instance_not_crashing() -> void:
	assert_object(element_instance).is_not_null()
