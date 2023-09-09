# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the spot light (not much)

##### VARIABLES #####
const spot_light_path = "res://test/UnitTests/MapElementsTests/Lights/spot_light_mock.tscn"


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = spot_light_path
	.before()

#---- TESTS -----
#==== ACTUAL TESTS =====
# Not much to test
