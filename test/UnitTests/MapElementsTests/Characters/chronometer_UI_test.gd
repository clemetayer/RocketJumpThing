# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the chronometer ui

##### VARIABLES #####
const chronometer_ui_path := "res://Game/Common/Characters/chronometer_UI.tscn"
var chronometer_ui: CanvasLayer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = chronometer_ui_path
	.before()
	chronometer_ui = load(chronometer_ui_path).instance()


func after():
	chronometer_ui.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	chronometer_ui._connect_signals()
	assert_bool(SignalManager.is_connected("start_level_chronometer", chronometer_ui, "_on_SignalManager_start_level_chronometer")).is_true()
	assert_bool(SignalManager.is_connected("end_reached", chronometer_ui, "_on_SignalManager_end_reached")).is_true()


func test_update_timer() -> void:
	chronometer_ui._timer_stopped = false
	chronometer_ui._last_time = 59999  # 59.999 seconds
	chronometer_ui._update_timer(0.1)  # + 100 ms
	assert_str(str(chronometer_ui._last_time)).is_equal("60099")  # assert_float not working on some cases
	# assert_float(chronometer_ui._last_time).is_equal(60099)  # = 60s 099ms
	assert_str(chronometer_ui.get_node("Background/CenterContainer/RichTextLabel").get_bbcode()).is_equal(
		"01 : 00 : 099"
	)


func test_on_SignalManager_start_level_chronometer() -> void:
	chronometer_ui._on_SignalManager_start_level_chronometer()
	assert_str(str(chronometer_ui._last_time)).is_equal("0")
	# assert_float(chronometer_ui._last_time).is_equal(0)
	assert_bool(chronometer_ui._timer_stopped).is_false()


func test_on_SignalManager_end_reached() -> void:
	chronometer_ui._on_SignalManager_end_reached()
	chronometer_ui._last_time = 1
	# assert_float(VariableManager.chronometer.level).is_equal(1) # TODO : cannot test the variable manager
	assert_bool(chronometer_ui._timer_stopped).is_true()

#==== UTILITIES =====
