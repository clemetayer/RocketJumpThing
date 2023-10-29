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
	player_ui.set_speed(100.638)
	assert_float(player_ui.speed).is_equal(100.64)
	assert_str(player_ui.onready_paths.speed_text.get_bbcode()).is_equal(
		TextUtils.BBCode_center_text(tr(TranslationKeys.PLAYER_UI_SPEED) % "100.64")
	)

func test_connect_signals() -> void:
	player_ui._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_CROSSHAIR,player_ui,"_on_SignalManager_update_crosshair")).is_true()
	assert_bool(player_ui.onready_paths.update_ui_init.is_connected("timeout",player_ui,"_on_UpdateUIOnInit_timeout")).is_true()

func test_set_crosshair() -> void:
	var test_crosshair_path := "res://Misc/UI/Crosshairs/PNG/WhiteRetina/crosshair002.png"
	player_ui._set_crosshair(test_crosshair_path, Color.blue, 2.0)
	assert_object(player_ui.onready_paths.crosshair.texture).is_not_null()
	assert_object(player_ui.onready_paths.crosshair.modulate).is_equal(Color.blue)
	assert_vector2(player_ui.onready_paths.crosshair_size_control.rect_scale).is_equal(Vector2.ONE * 2.0)

# No need to test _on_SignalManager_update_crosshair and _on_UpdateUIOnInit_timeout since they just call _set_crosshair
