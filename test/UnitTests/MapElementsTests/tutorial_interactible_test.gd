# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the tutorial interactible

##### VARIABLES #####
const tutorial_interactible_path := "res://Game/Common/MapElements/TutorialTrigger/tutorial_interactible.tscn"
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
	SettingsUtils.settings_data.gameplay.tutorial_level = SettingsUtils.TUTORIAL_LEVEL.all
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
	assert_bool(SignalManager.is_connected(SignalManager.TRIGGER_TUTORIAL,tutorial_interactible,"_on_SignalManager_trigger_tutorial")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_SETTINGS,tutorial_interactible,"_on_SignalManager_update_settings")).is_true()

func test_on_SignalManager_trigger_tutorial() -> void:
	tutorial_interactible._key = "test"
	tutorial_interactible._toggle_active(false)
	tutorial_interactible._on_SignalManager_trigger_tutorial("not test",1.0)
	assert_bool(tutorial_interactible.visible).is_false()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_true()
	SettingsUtils.settings_data.gameplay.tutorial_level = SettingsUtils.TUTORIAL_LEVEL.none
	tutorial_interactible._on_SignalManager_trigger_tutorial("test",1.0)
	assert_bool(tutorial_interactible.visible).is_false()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_true()
	SettingsUtils.settings_data.gameplay.tutorial_level = SettingsUtils.TUTORIAL_LEVEL.all
	tutorial_interactible._on_SignalManager_trigger_tutorial("test",1.0)
	assert_bool(tutorial_interactible.visible).is_true()
	assert_bool(tutorial_interactible.onready_path.collision_shape.disabled).is_false()

func test_on_area_tutorial_trigger_body_entered() -> void:
	var not_player = KinematicBody.new()
	var player = KinematicBody.new()
	player.add_to_group(GlobalConstants.PLAYER_GROUP)
	tutorial_interactible._on_area_tutorial_trigger_body_entered(not_player)
	assert_signal(SignalManager).is_not_emitted(SignalManager.TRIGGER_TUTORIAL)
	tutorial_interactible._on_area_tutorial_trigger_body_entered(player)
	assert_signal(SignalManager).is_emitted(SignalManager.TRIGGER_TUTORIAL)
	not_player.free()
	player.free()
	
