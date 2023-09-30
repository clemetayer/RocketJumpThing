# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# description

##### VARIABLES #####
const dodecahedron_path := "res://Game/Scenes/Levels/Level5/Core2/Dodecahedron.tscn"
var dodecahedron


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = dodecahedron_path
	.before()
	dodecahedron = load(dodecahedron_path).instance()
	dodecahedron._ready()

func after():
	dodecahedron.free()
	.after()
