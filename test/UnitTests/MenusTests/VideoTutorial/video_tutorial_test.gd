# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the video tutorial

##### VARIABLES #####
const video_tutorial_path := "res://Game/Common/Menus/VideoTutorial/video_tutorial.tscn"
var video_tutorial


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = video_tutorial_path
	.before()
	video_tutorial = load(video_tutorial_path).instance()
	video_tutorial._ready()

func after():
	video_tutorial.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
# Play and stop video can't really be tested for some reason

func test_connect_signals() -> void:
	video_tutorial._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.TRANSLATION_UPDATED, video_tutorial, "_on_SignalManager_translation_updated")).is_true()
	assert_bool(video_tutorial.onready_paths.video_player.is_connected("finished", video_tutorial, "_on_VideoPlayer_finished")).is_true()

func test_on_SignalManager_translation_updated() -> void:
	video_tutorial._on_SignalManager_translation_updated()
	assert_str(video_tutorial.onready_paths.escape_label.text).is_equal(tr(TranslationKeys.TUTORIAL_ESCAPE_TO_SKIP))
