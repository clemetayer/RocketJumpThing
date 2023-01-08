# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Kind of hard to test cleanly. Just the basics, I suppose

##### VARIABLES #####
const rotating_laser_path := "res://test/UnitTests/MapElementsTests/Laser/rotating_laser_mock.tscn"
var rotating_laser


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rotating_laser_path
	.before()
	rotating_laser = load(rotating_laser_path).instance()
	rotating_laser._ready()


func after():
	rotating_laser.free()
	.after()
