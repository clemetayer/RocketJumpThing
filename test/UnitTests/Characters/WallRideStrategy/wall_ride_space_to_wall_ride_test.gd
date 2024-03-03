# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the space to wall ride strategy

##### VARIABLES #####
const scene_path := "res://test/UnitTests/Characters/WallRideStrategy/wall_ride_space_to_wall_ride_mock.tscn"
var scene


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = scene_path
	.before()
	scene = load(scene_path).instance()

func after():
	scene.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
