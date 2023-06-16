# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends StandardDoorTest
# tests for the door with a counter


##### TESTS #####
#---- PRE/POST -----
func before():
	standard_door_path = "res://test/UnitTests/MapElementsTests/Doors/cnt_standard_door_mock.tscn"
	.before()

#---- TESTS -----
# TODO : How to test that the "use" of the parent of CntStandardDoor has been called ?