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
	var song = SongAnimationPlayer.new()
	var player = load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	song.ANIMATION = "test"
	StandardSongManager._current_song = song
	checkpoint._on_Checkpoint_body_entered(player)
	assert_signal(SignalManager).is_emitted("checkpoint_triggered", [checkpoint])
	assert_str(checkpoint.song_animation).is_equal("test")
	player.free()
	song.free()
