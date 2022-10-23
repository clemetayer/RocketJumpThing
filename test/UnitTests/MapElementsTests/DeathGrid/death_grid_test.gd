# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the death grid

##### VARIABLES #####
const death_grid_path := "res://test/UnitTests/MapElementsTests/DeathGrid/death_grid_mock.tscn"
var death_grid


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = death_grid_path
	.before()
	death_grid = load(death_grid_path).instance()


func after():
	death_grid.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	death_grid._connect_signals()
	assert_bool(death_grid.is_connected("body_exited", death_grid, "_on_body_exited")).is_true()


func test_on_body_exited() -> void:
	var player = load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	death_grid._on_body_exited(player)
	assert_signal(SignalManager).is_emitted("respawn_player_on_last_cp")
	player.free()
