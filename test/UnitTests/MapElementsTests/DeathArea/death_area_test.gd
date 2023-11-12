# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the death area

##### VARIABLES #####
const death_area_path := "res://test/UnitTests/MapElementsTests/DeathArea/death_area_mock.tscn"
var death_area


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = death_area_path
	.before()
	death_area = load(death_area_path).instance()


func after():
	death_area.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	death_area._connect_signals()
	assert_bool(death_area.is_connected("body_entered", death_area, "_on_body_entered")).is_true()


func test_on_body_entered() -> void:
	var player = load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	death_area._on_body_entered(player)
	assert_bool(RuntimeUtils.paths.death_sound.is_playing()).is_true()
	# assert_signal(SignalManager).is_emitted(SignalManager.RESPAWN_PLAYER_ON_LAST_CP)
	player.free()
