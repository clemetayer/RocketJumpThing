# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the tutorial hints
# TODO : test in more depth after the refactor

##### VARIABLES #####
const tutorial_hints_path := "res://Game/Common/MapElements/Characters/tutorial_hints.tscn"
var tutorial_hints: CanvasLayer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = tutorial_hints_path
	.before()
	tutorial_hints = load(tutorial_hints_path).instance()


func after():
	tutorial_hints.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====

# TODO : display_tutorial complex to test because of the tweens
