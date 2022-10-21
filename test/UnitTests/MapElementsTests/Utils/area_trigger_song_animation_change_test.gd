# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the area that changes the song animation

##### VARIABLES #####
const area_path := "res://test/UnitTests/MapElementsTests/Utils/area_trigger_song_animation_change_mock.tscn"
var area


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = area_path
	.before()
	area = load(area_path).instance()


func after():
	area.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	area._connect_signals()
	assert_bool(area.is_connected("body_entered", area, "_on_body_entered"))


func test_on_body_entered() -> void:
	area.properties = {"animation": "test"}
	var player := load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	var song = SongAnimationPlayer.new()
	song.ANIMATION = "test2"
	StandardSongManager._current_song = song
	area._on_body_entered(player)
	assert_array(StandardSongManager._queue).is_not_empty()
	var added_element = StandardSongManager._queue.pop_back()
	assert_str(added_element.song.ANIMATION).is_equal("test")
	assert_bool(added_element.effect is FilterEffectManager).is_true()
	player.free()
	song.free()
	added_element.song.free()
	added_element.effect.free()
