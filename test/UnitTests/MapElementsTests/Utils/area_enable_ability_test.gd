# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the enable ability area

##### VARIABLES #####
const TOGGLE_ABILITY_UI_PATH := "res://Game/Common/MapElements/Characters/toggle_ability_ui.tscn"
const area_enable_ability_path := "res://test/UnitTests/MapElementsTests/Utils/area_enable_ability_mock.tscn"
var area_enable_ability


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = area_enable_ability_path
	.before()
	area_enable_ability = load(area_enable_ability_path).instance()


func after():
	area_enable_ability.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	area_enable_ability._connect_signals()
	assert_bool(
		area_enable_ability.is_connected("body_entered", area_enable_ability, "_on_body_entered")
	)


func test_on_body_entered() -> void:
	var toggle_ability_ui = load(TOGGLE_ABILITY_UI_PATH).instance()
	toggle_ability_ui._ready()
	area_enable_ability._slide = true
	area_enable_ability._rockets = true
	var player = load(GlobalTestUtilities.player_path).instance()
	player.ROCKETS_ENABLED = false
	player.SLIDE_ENABLED = false
	player.add_to_group("player")
	player.onready_paths = {}
	player.onready_paths.rocket_launcher = MeshInstance.new()
	player.onready_paths.rocket_launcher.visible = player.ROCKETS_ENABLED
	player.onready_paths.toggle_ability_ui = toggle_ability_ui
	area_enable_ability._on_body_entered(player)
	assert_bool(player.ROCKETS_ENABLED).is_true()
	assert_bool(player.SLIDE_ENABLED).is_true()
	assert_bool(player.onready_paths.rocket_launcher.visible).is_true()
	area_enable_ability._slide = false
	area_enable_ability._rockets = false
	area_enable_ability._on_body_entered(player)
	assert_bool(player.ROCKETS_ENABLED).is_false()
	assert_bool(player.SLIDE_ENABLED).is_false()
	assert_bool(player.onready_paths.rocket_launcher.visible).is_false()
	player.onready_paths.rocket_launcher.free()
	toggle_ability_ui.free()
	player.free()


