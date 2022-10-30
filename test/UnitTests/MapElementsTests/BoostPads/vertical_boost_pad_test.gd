# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends VerticalBoostTest
# tests the vertical boost pad


##### TESTS #####
#---- PRE/POST -----
func before():
	vertical_boost_path = "res://Game/Common/MapElements/BoostPads/Vertical/vertical_boost_pad.tscn"
	.before()


func test_connect_signals_pad() -> void:
	.test_connect_signals()
	assert_bool(vertical_boost.onready_gradient_tween.is_connected("tween_step", vertical_boost, "_on_gradient_tween_step")).is_true()

# just tests from the parent, not much to do here
