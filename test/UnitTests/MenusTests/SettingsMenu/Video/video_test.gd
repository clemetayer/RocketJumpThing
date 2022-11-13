# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the video settings tab

##### VARIABLES #####
const video_path := "res://Game/Common/Menus/SettingsMenu/Video/video.tscn"
var video


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = video_path
	.before()
	video = load(video_path).instance()
	video._ready()


func after():
	.after()
	video.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	video._connect_signals()
	assert_bool(video.onready_paths.options.is_connected("item_selected", video, "_on_Options_item_selected")).is_true()


func test_init_options() -> void:
	var fullscreen := false
	OS.window_fullscreen = fullscreen
	video.onready_paths.options.clear()
	video._init_options()
	assert_int(video.onready_paths.options.get_item_count()).is_equal(2)
	assert_str(video.onready_paths.options.get_item_text(video.window_modes.FULL_SCREEN)).is_equal(
		tr(video.FULL_SCREEN_LABEL)
	)
	assert_str(video.onready_paths.options.get_item_text(video.window_modes.WINDOWED)).is_equal(
		tr(video.WINDOWED_LABEL)
	)
	assert_int(video.onready_paths.options.get_selected_id()).is_equal(
		video.window_modes.FULL_SCREEN if fullscreen else video.window_modes.WINDOWED
	)


func test_on_Options_item_selected() -> void:
	# full screen
	video._on_Options_item_selected(video.window_modes.FULL_SCREEN)
	assert_bool(OS.window_fullscreen).is_true()
	# windowed
	video._on_Options_item_selected(video.window_modes.WINDOWED)
	assert_bool(OS.window_fullscreen).is_false()
