# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the loading screen

##### VARIABLES #####
const loading_screen_path := "res://Game/Common/Menus/LoadingScreen/loading_screen.tscn"
var loading_screen


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = loading_screen_path
	.before()
	loading_screen = load(loading_screen_path).instance()
	loading_screen._ready()


func after():
	loading_screen.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signal() -> void:
	loading_screen._connect_signals()
	assert_bool(loading_screen.onready_paths.animation_player.is_connected("animation_finished",loading_screen,"_on_AnimationPlayer_animation_finished")).is_true()

func test_appear() -> void:
	var level_name = "TEST"
	loading_screen.LEVEL_NAME = level_name
	loading_screen.appear()
	assert_str(loading_screen.onready_paths.level_name_label.text).is_equal(level_name)
	assert_bool(loading_screen.onready_paths.animation_player.is_playing()).is_true()
	assert_str(loading_screen.onready_paths.animation_player.current_animation).is_equal(loading_screen.APPEAR_ANIM_NAME)

func test_disappear() -> void:
	loading_screen.disappear()
	assert_bool(loading_screen.onready_paths.animation_player.is_playing()).is_true()
	assert_str(loading_screen.onready_paths.animation_player.current_animation).is_equal(loading_screen.DISAPPEAR_ANIM_NAME)

