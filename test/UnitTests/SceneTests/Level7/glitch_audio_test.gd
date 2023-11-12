# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the glitch audio thing for the level 7

##### VARIABLES #####
const glitch_audio_path := "res://test/UnitTests/SceneTests/Level7/glitch_audio_test_mock.tscn"
var glitch_audio


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = glitch_audio_path
	.before()
	glitch_audio = load(glitch_audio_path).instance()
	glitch_audio._ready()

func after():
	glitch_audio.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	glitch_audio._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.GLITCH_AUDIO,glitch_audio,"_on_SignalManager_glitch_audio")).is_true()

func test_on_SignalManager_glitch_audio() -> void:
	glitch_audio._on_SignalManager_glitch_audio(0)
	assert_bool(glitch_audio.onready_paths.audio_stream_player.is_playing()).is_true()
	assert_object(glitch_audio.onready_paths.audio_stream_player.stream).is_equal(glitch_audio.GLITCH_SAMPLES["200ms"])
	glitch_audio._on_SignalManager_glitch_audio(1)
	assert_bool(glitch_audio.onready_paths.audio_stream_player.is_playing()).is_true()
	assert_object(glitch_audio.onready_paths.audio_stream_player.stream).is_equal(glitch_audio.GLITCH_SAMPLES["500ms"])
	glitch_audio._on_SignalManager_glitch_audio(2)
	assert_bool(glitch_audio.onready_paths.audio_stream_player.is_playing()).is_true()
	assert_object(glitch_audio.onready_paths.audio_stream_player.stream).is_equal(glitch_audio.GLITCH_SAMPLES["1s"])
	glitch_audio._on_SignalManager_glitch_audio(3)
	assert_bool(glitch_audio.onready_paths.audio_stream_player.is_playing()).is_true()
	assert_object(glitch_audio.onready_paths.audio_stream_player.stream).is_equal(glitch_audio.GLITCH_SAMPLES["3s"])
