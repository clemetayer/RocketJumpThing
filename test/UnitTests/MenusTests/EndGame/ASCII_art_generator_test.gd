# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the ascii art generator from image

##### VARIABLES #####
const generator_path := "res://Game/Common/Menus/EndGame/ASCIIArtGenerator.tscn"
var generator: TextureRect


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = generator_path
	.before()
	generator = load(generator_path).instance()


func after():
	generator.free()
	.after()



