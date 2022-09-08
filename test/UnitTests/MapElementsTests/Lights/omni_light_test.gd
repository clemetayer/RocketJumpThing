# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the omni light (not much)

##### VARIABLES #####
const omni_light_path = "res://test/UnitTests/MapElementsTests/Lights/omni_light_mock.tscn"


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = omni_light_path
	.before()

#---- TESTS -----
#==== ACTUAL TESTS =====
# Not much to test
