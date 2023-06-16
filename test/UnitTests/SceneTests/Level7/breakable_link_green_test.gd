# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# kind of tests the green breakable link

##### VARIABLES #####
const breakable_link_path := "res://Game/Scenes/Levels/Level7/BreakableLink/breakable_link_green.tscn"
var breakable_link: Spatial


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = breakable_link_path
	.before()
	breakable_link = load(breakable_link_path).instance()


func after():
	breakable_link.free()
	.after()
