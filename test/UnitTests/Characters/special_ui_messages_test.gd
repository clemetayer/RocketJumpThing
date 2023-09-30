# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# description

##### VARIABLES #####
const messages_path := "res://Game/Common/MapElements/Characters/special_ui_messages.tscn"
var messages


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = messages_path
	.before()
	messages = load(messages_path).instance()
	messages._ready()

func after():
	messages.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_ready() -> void:
	messages._ready()
	assert_bool(SignalManager.is_connected(SignalManager.UI_MESSAGE,messages,"_on_SignalManager_ui_message")).is_true()
	assert_bool(messages.visible).is_false()

func test_on_SignalManager_ui_message() -> void:
	var test_message = "test"
	messages._on_SignalManager_ui_message(test_message)
	assert_str(messages.onready_paths.rtl.bbcode_text).is_equal(test_message)
	assert_bool(messages.onready_paths.animation_player.is_playing()).is_true()
	assert_str(messages.onready_paths.animation_player.current_animation).is_equal(messages.APPEAR_DISAPPEAR_ANIM_NAME)
