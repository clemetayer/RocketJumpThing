# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the checkpoint

##### VARIABLES #####
const checkpoint_ui_path := "res://Game/Common/Characters/checkpoint_UI.tscn"
var checkpoint_ui: CanvasLayer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = checkpoint_ui_path
	.before()
	checkpoint_ui = load(checkpoint_ui_path).instance()


func after():
	checkpoint_ui.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_UI() -> void:
	checkpoint_ui._init_UI()
	assert_float(checkpoint_ui.get_node("CenterContainer").modulate.a).is_zero()
	assert_str(checkpoint_ui.get_node("CenterContainer/MarginContainer/RichTextLabel").get_bbcode()).is_not_empty()


func test_connect_signals() -> void:
	checkpoint_ui._connect_signals()
	assert_bool(SignalManager.is_connected("checkpoint_triggered", checkpoint_ui, "_on_SignalManager_checkpoint_triggered")).is_true()

# TODO : complex to test the tweens for _displa_effect

# useless to test _on_SignalManager_checkpoint_triggered
