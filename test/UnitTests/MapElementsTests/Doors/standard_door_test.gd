# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the standard door

##### VARIABLES #####
const standard_door_path := "res://test/UnitTests/MapElementsTests/Doors/standard_door_mock.tscn"
var standard_door


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = standard_door_path
	.before()
	standard_door = load(standard_door_path).instance()


func after():
	standard_door.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
# TODO : hard to test because of the tweens
