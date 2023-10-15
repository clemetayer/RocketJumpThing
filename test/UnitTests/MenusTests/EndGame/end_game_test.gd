# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# End game tests

##### VARIABLES #####
const end_game_path := "res://Game/Common/Menus/EndGame/end_game.tscn"
var end_game


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = end_game_path
	.before()
	end_game = load(end_game_path).instance()

func after():
	end_game.free()
	.after()
