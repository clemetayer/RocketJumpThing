# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the standard wall ride strategy

##### VARIABLES #####
const scene_path := "res://test/UnitTests/Characters/WallRideStrategy/wall_ride_standard_mock.tscn"
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
# TODO : Scene runner and inputs/method calls does not work really well
# that means we can't test much here sadly :/
