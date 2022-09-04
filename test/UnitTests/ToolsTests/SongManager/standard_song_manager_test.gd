# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Test of the Standard song manager

##### VARIABLES #####
const song_manager_path = "res://test/UnitTests/ToolsTests/SongManager/standard_song_manager_mock.tscn"
var song_manager: SongManager


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = song_manager_path
	.before()


func before_test():
	song_manager = load(song_manager_path).instance()


func after_test():
	song_manager.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_add_to_queue() -> void:
	var song := Song.new()
	var effect := EffectManager.new()
	song_manager.add_to_queue(song, effect)
	assert_array(song_manager._queue).is_equal([{"song": song, "effect": effect}])
	song.free()
	effect.free()


# also tests switch_song,update_current and play_song
func test_queue_management() -> void:
	# mock init
	var song_1_mock = mock(Song)
	song_1_mock.name = "test"
	var song_2_mock = mock(Song)
	song_2_mock.name = "test"
	var song_3_mock = mock(Song)
	song_3_mock.name = "test_2"
	var effect_1_mock = mock(EffectManager)
	var effect_2_mock = mock(EffectManager)
	var effect_3_mock = mock(EffectManager)

	# methods mock
	do_return([]).on(song_1_mock).play()
	do_return([]).on(song_1_mock).update(song_1_mock)
	do_return([]).on(song_1_mock).update(song_2_mock)
	do_return([]).on(song_1_mock).update(song_3_mock)
	do_return([]).on(song_1_mock).stop()
	do_return([]).on(song_2_mock).play()
	do_return([]).on(song_2_mock).update(song_1_mock)
	do_return([]).on(song_2_mock).update(song_2_mock)
	do_return([]).on(song_2_mock).update(song_3_mock)
	do_return([]).on(song_2_mock).stop()
	do_return([]).on(song_3_mock).play()
	do_return([]).on(song_3_mock).update(song_1_mock)
	do_return([]).on(song_3_mock).update(song_2_mock)
	do_return([]).on(song_3_mock).update(song_3_mock)
	do_return([]).on(song_3_mock).stop()
	do_return(effect_1_mock).on(effect_1_mock).duplicate()
	do_return(effect_2_mock).on(effect_2_mock).duplicate()
	do_return(effect_3_mock).on(effect_3_mock).duplicate()

	#testing
	song_manager.add_to_queue(song_1_mock, effect_1_mock)
	song_manager._queue_management()
	verify(song_1_mock, 1).play()
	verify(effect_1_mock, 1).start_effect([])
	song_manager.add_to_queue(song_2_mock, effect_2_mock)
	song_manager._queue_management()
	verify(song_1_mock, 1).update(song_2_mock)
	verify(effect_2_mock, 1).start_effect([])
	song_manager.add_to_queue(song_3_mock, effect_3_mock)
	song_manager._queue_management()
	verify(song_1_mock, 1).stop()
	verify(effect_3_mock, 1).start_effect([])


func test_stop_current() -> void:
	var song_mock = mock(Song)
	var effect_mock = mock(EffectManager)
	do_return([]).on(song_mock).stop()
	song_manager._current_song = song_mock
	song_manager.stop_current(effect_mock)
	verify(song_mock, 1).stop()
	verify(effect_mock, 1).init_updating_properties([])
	verify(effect_mock, 1).start_effect([])


func test_apply_effect() -> void:
	var song_mock = mock(Song)
	var effect_mock = mock(EffectManager)
	do_return([]).on(song_mock).get_neutral_effect_data({})
	song_manager._current_song = song_mock
	song_manager.apply_effect(effect_mock)
	verify(song_mock, 1).get_neutral_effect_data({})
	verify(effect_mock, 1).init_updating_properties([])
	verify(effect_mock, 1).start_effect([])

#==== UTILITIES =====
