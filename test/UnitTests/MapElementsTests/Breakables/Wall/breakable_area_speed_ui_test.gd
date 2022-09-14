# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the breakable area speed ui

##### VARIABLES #####
const breakable_area_speed_ui_path := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_speed_ui.tscn"
var breakable_area_speed_ui


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = breakable_area_speed_ui_path
	.before()
	breakable_area_speed_ui = load(breakable_area_speed_ui_path).instance()


func after():
	breakable_area_speed_ui.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	breakable_area_speed_ui._connect_signals()
	assert_bool(
		SignalManager.is_connected(
			"speed_updated", breakable_area_speed_ui, "_on_breakable_area_speed_ui_speed_updated"
		)
	)


func test_init_label() -> void:
	breakable_area_speed_ui.SPEED = 100
	breakable_area_speed_ui._init_label()
	assert_str(breakable_area_speed_ui.get_node("Label").text).is_equal("100")
	assert_vector2(breakable_area_speed_ui.size).is_equal(
		breakable_area_speed_ui.get_node("Label").rect_size
	)


func test_on_breakable_area_speed_ui_speed_updated() -> void:
	breakable_area_speed_ui.SPEED = 100
	breakable_area_speed_ui._on_breakable_area_speed_ui_speed_updated(101)
	assert_object(breakable_area_speed_ui.get_node("Label").get("custom_colors/font_color")).is_equal(
		breakable_area_speed_ui.COLOR_OK
	)
	breakable_area_speed_ui._on_breakable_area_speed_ui_speed_updated(99)
	assert_object(breakable_area_speed_ui.get_node("Label").get("custom_colors/font_color")).is_equal(
		breakable_area_speed_ui.COLOR_NOK
	)
