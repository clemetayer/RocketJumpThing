# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests some camera utils

##### VARIABLES #####
const camera_utils_path := "res://test/UnitTests/Camera/camera_utils_mock.tscn"


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = camera_utils_path
	.before()

#---- TESTS -----
#==== ACTUAL TESTS =====
