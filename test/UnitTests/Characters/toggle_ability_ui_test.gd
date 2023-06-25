# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the toggle ability ui

##### VARIABLES #####
const TOGGLE_ABILITY_UI_PATH := "res://Game/Common/MapElements/Characters/toggle_ability_ui.tscn"
var toggle_ability_ui: CanvasLayer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = TOGGLE_ABILITY_UI_PATH
	.before()
	toggle_ability_ui = load(TOGGLE_ABILITY_UI_PATH).instance()
	toggle_ability_ui._ready()


func after():
	toggle_ability_ui.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_toggle_rocket() -> void:
	toggle_ability_ui.toggle_rocket(true)
	assert_bool(toggle_ability_ui.onready_paths.animation_player.is_playing()).is_true()
	assert_str(toggle_ability_ui.onready_paths.animation_player.current_animation).is_equal(toggle_ability_ui.ROCKET_ON_ANIM_NAME)
	toggle_ability_ui.toggle_rocket(false)
	assert_bool(toggle_ability_ui.onready_paths.animation_player.is_playing()).is_true()
	assert_str(toggle_ability_ui.onready_paths.animation_player.current_animation).is_equal(toggle_ability_ui.ROCKET_OFF_ANIM_NAME)

func test_toggle_slide() -> void:
	toggle_ability_ui.toggle_slide(true)
	assert_bool(toggle_ability_ui.onready_paths.animation_player.is_playing()).is_true()
	assert_str(toggle_ability_ui.onready_paths.animation_player.current_animation).is_equal(toggle_ability_ui.SLIDE_ON_ANIM_NAME)
	toggle_ability_ui.toggle_slide(false)
	assert_bool(toggle_ability_ui.onready_paths.animation_player.is_playing()).is_true()
	assert_str(toggle_ability_ui.onready_paths.animation_player.current_animation).is_equal(toggle_ability_ui.SLIDE_OFF_ANIM_NAME)
	
