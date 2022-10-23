# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the breakable area ui

##### VARIABLES #####
const breakable_area_ui_path := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_rocket_ui.tscn"
var breakable_area_ui


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = breakable_area_ui_path
	.before()
	breakable_area_ui = load(breakable_area_ui_path).instance()
	breakable_area_ui._ready()


func after():
	breakable_area_ui.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_texture_rect() -> void:
	breakable_area_ui._init_texture_rect()
	assert_vector2(breakable_area_ui.size).is_equal(
		breakable_area_ui.get_node("TextureRect").rect_size
	)
	assert_object(breakable_area_ui.get_node("TextureRect").modulate).is_equal(
		breakable_area_ui.COLOR_NOK
	)
