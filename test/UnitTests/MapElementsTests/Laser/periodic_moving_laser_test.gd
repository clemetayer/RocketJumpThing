# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Kind of hard to test cleanly. Just the basics, I suppose

##### VARIABLES #####
const periodic_moving_laser_path := "res://test/UnitTests/MapElementsTests/Laser/rotating_laser_mock.tscn"
var periodic_moving_laser


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = periodic_moving_laser_path
	.before()
	periodic_moving_laser = load(periodic_moving_laser_path).instance()
	periodic_moving_laser._ready()


func after():
	periodic_moving_laser.free()
	.after()
