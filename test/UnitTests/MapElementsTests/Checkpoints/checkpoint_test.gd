# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the checkpoint
# NOTE : can be a test parent class if the start point is getting more complex

##### VARIABLES #####
const checkpoint_path := "res://test/UnitTests/MapElementsTests/Checkpoints/checkpoint_mock.tscn"
var checkpoint


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = checkpoint_path
	.before()
	checkpoint = load(checkpoint_path).instance()
	checkpoint._test_mode = true
	checkpoint._ready()


func after():
	checkpoint.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	checkpoint._connect_signals()
	assert_bool(checkpoint.is_connected("body_entered", checkpoint, "_on_Checkpoint_body_entered")).is_true()

func test_on_Checkpoint_body_entered() -> void:
	var player = load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	player.ROCKETS_ENABLED = true
	player.SLIDE_ENABLED = false
	checkpoint._on_Checkpoint_body_entered(player)
	assert_signal(SignalManager).is_emitted(SignalManager.CHECKPOINT_TRIGGERED, [checkpoint])
	assert_bool(checkpoint._entered_sound.is_playing()).is_true()
	assert_bool(checkpoint.slide_enabled).is_false()
	assert_bool(checkpoint.rockets_enabled).is_true()
	player.free()
