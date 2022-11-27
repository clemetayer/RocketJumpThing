# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the player UI

##### VARIABLES #####
const player_ui_path := "res://Game/Common/MapElements/Characters/player_UI.tscn"
var player_ui: CanvasLayer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = player_ui_path
	.before()
	player_ui = load(player_ui_path).instance()
	player_ui._ready()


func after():
	player_ui.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_set_speed() -> void:
	player_ui.set_speed(100.6)
	assert_float(player_ui.speed).is_equal(101)
	assert_str(player_ui.get_node("Screen/MarginScreen/CenterScreen/SpeedContainer/SpeedText").get_bbcode()).is_equal(TextUtils.BBCode_center_text(tr(TranslationKeys.PLAYER_UI_SPEED % "101")))
