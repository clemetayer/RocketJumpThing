# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the video tutorial interactible

##### VARIABLES #####
const tutorial_interactible_path := "res://Game/Common/MapElements/TutorialTrigger/video_tutorial_interactible.tscn"
var tutorial_interactible


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = tutorial_interactible_path
	.before()
	tutorial_interactible = load(tutorial_interactible_path).instance()
	tutorial_interactible._ready()


func after():
	tutorial_interactible.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_ready_activate_tutorial() -> void:
	SettingsUtils.settings_data.gameplay.tutorial_level = SettingsUtils.TUTORIAL_LEVEL.none
	tutorial_interactible._ready_activate_tutorial()
	assert_bool(tutorial_interactible.visible).is_false()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_true()
	SettingsUtils.settings_data.gameplay.tutorial_level = SettingsUtils.TUTORIAL_LEVEL.some
	tutorial_interactible._ready_activate_tutorial()
	assert_bool(tutorial_interactible.visible).is_true()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_false()

func test_toggle_active() -> void:
	tutorial_interactible._toggle_active(true)
	assert_bool(tutorial_interactible.visible).is_true()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_false()
	tutorial_interactible._toggle_active(false)
	assert_bool(tutorial_interactible.visible).is_false()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_true()

func test_connect_signals() -> void:
	tutorial_interactible._connect_signals()
	assert_bool(tutorial_interactible.is_connected("body_entered",tutorial_interactible,"_on_area_tutorial_trigger_body_entered")).is_true()
	
