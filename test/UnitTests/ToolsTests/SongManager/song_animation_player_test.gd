# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the song animation player
# Note : should be set in debug mode, because without it, it fails to load the song_anim_player for some reason in normal mode

##### VARIABLES #####
const TRACK_1 := "Track1"
const TRACK_2 := "Track2"
const SONG_ANIMATION_PLAYER := "SongAnimationPlayer"
const PATHS = {  # paths to the tracks of the song animation player
	"track_1": TRACK_1, "track_2": "SubTracks/" + TRACK_2, "animation_player": "AnimationPlayer"
}
const song_anim_player_path = "res://test/UnitTests/ToolsTests/SongManager/song_animation_player_mock.tscn"
var s_a_p: SongAnimationPlayer


##### PROCESSING #####
func before():
	element_path = song_anim_player_path
	.before()


func before_test():
	s_a_p = load(song_anim_player_path).instance()


func after_test():
	s_a_p.free()


##### TEST FUNCTIONS #####
# Test of the init methods (tracks and buses)
func test_init() -> void:
	_test_init_tracks()
	_test_init_buses()


func _test_init_tracks() -> void:
	s_a_p._init_tracks()
	var tracks = {
		SONG_ANIMATION_PLAYER: {"bus": "", "volume": 0.0},
		TRACK_1:
		{
			"bus": "",
			"path": NodePath(PATHS.track_1),
			"volume": 0.0,
			"playing_in_animation": ["anim_1", "anim_3"]
		},
		TRACK_2:
		{
			"bus": "",
			"path": NodePath(PATHS.track_2),
			"volume": 0.0,
			"playing_in_animation": ["anim_2", "anim_3"]
		}
	}
	assert_dict(s_a_p._tracks).is_equal(tracks)


func _test_init_buses() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	assert_int(AudioServer.get_bus_index(SONG_ANIMATION_PLAYER)).is_not_equal(-1)
	assert_int(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_1])).is_not_equal(
		-1
	)
	assert_int(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2])).is_not_equal(
		-1
	)
	assert_str(s_a_p.get_node(PATHS.track_1).bus).is_equal(
		"%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_1]
	)
	assert_str(s_a_p.get_node(PATHS.track_2).bus).is_equal(
		"%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2]
	)
	assert_str(s_a_p._tracks[SONG_ANIMATION_PLAYER].bus).is_equal(SONG_ANIMATION_PLAYER)
	assert_str(s_a_p._tracks[TRACK_1].bus).is_equal("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_1])
	assert_str(s_a_p._tracks[TRACK_2].bus).is_equal("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2])
	s_a_p._clear_buses()


func test_play() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	assert_array(s_a_p.play()).is_equal(s_a_p._get_track_effect_array(SONG_ANIMATION_PLAYER, true))
	assert_bool(s_a_p.get_node(PATHS.animation_player).is_playing()).is_true()
	s_a_p._clear_buses()


func test_stop() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	s_a_p.stop()
	assert_array(s_a_p.stop()).is_equal(s_a_p._get_track_effect_array(SONG_ANIMATION_PLAYER, false))
	assert_bool(s_a_p._update_track_infos.fade_out.has(SONG_ANIMATION_PLAYER)).is_true()
	s_a_p._clear_buses()


# test of the update method for animations that does not have the same tracks (completely)
func test_update_different_tracks() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	s_a_p.get_node(PATHS.track_1).play()  # emulates the animation_player actually started by playing track 1
	# Test switching with (strictly) different tracks (anim_1 -> anim_2)
	var song = load(song_anim_player_path).instance()
	song.ANIMATION = "anim_2"
	var effect_array = []
	effect_array.append_array(s_a_p._get_track_effect_array(TRACK_1, false))
	effect_array.append_array(s_a_p._get_track_effect_array(TRACK_2, true))
	assert_array(s_a_p.update(song)).is_equal(effect_array)
	assert_str(s_a_p._update_track_infos.animation).is_equal("anim_2")
	assert_array(s_a_p._update_track_infos.fade_out).is_equal([["Track1"]])
	assert_bool(s_a_p.get_node(PATHS.track_1).playing).is_true()  # meant to be stopped, but should still be playing during fade out
	assert_bool(s_a_p.get_node(PATHS.track_2).playing).is_true()
	song.free()
	s_a_p._clear_buses()


# test of the update method for animations that have at least one track in common, and other tracks fading in
# TODO : Cannot test play time since _get_animation_time_from_track_time is returning weird values due to the test execution
func test_update_common_tracks_fade_in() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	s_a_p.play()
	s_a_p.get_node(PATHS.track_1).play()  # emulates the animation_player actually started by playing track 1
	# Test switching with (strictly) different tracks (anim_1 -> anim_2)
	var song = load(song_anim_player_path).instance()
	song.ANIMATION = "anim_3"
	var effect_array = []
	effect_array.append_array(s_a_p._get_track_effect_array(TRACK_2, true))
	assert_array(s_a_p.update(song)).is_equal(effect_array)
	assert_str(s_a_p._update_track_infos.animation).is_equal("anim_3")
	assert_array(s_a_p._update_track_infos.fade_out).is_equal([[]])
	assert_bool(s_a_p.get_node(PATHS.track_1).playing).is_true()
	assert_bool(s_a_p.get_node(PATHS.track_2).playing).is_true()
	song.free()
	s_a_p._clear_buses()


# test of the update method for animations that have at least one track in common, and other tracks fading out
# TODO : Cannot test play time since _get_animation_time_from_track_time is returning weird values due to the test execution
func test_update_common_tracks_fade_out() -> void:
	s_a_p.ANIMATION = "anim_3"
	s_a_p._init_tracks()
	s_a_p._init_buses()
	s_a_p.play()
	s_a_p.get_node(PATHS.track_1).play()  # emulates the animation_player actually started by playing track 1
	s_a_p.get_node(PATHS.track_2).play()  # emulates the animation_player actually started by playing track 2
	# Test switching with (strictly) different tracks (anim_1 -> anim_2)
	var song = load(song_anim_player_path).instance()
	song.ANIMATION = "anim_2"
	var effect_array = []
	effect_array.append_array(s_a_p._get_track_effect_array(TRACK_1, false))
	assert_array(s_a_p.update(song)).is_equal(effect_array)
	assert_str(s_a_p._update_track_infos.animation).is_equal("anim_2")
	assert_array(s_a_p._update_track_infos.fade_out).is_equal([["Track1"]])
	assert_bool(s_a_p.get_node(PATHS.track_1).playing).is_true()
	assert_bool(s_a_p.get_node(PATHS.track_2).playing).is_true()
	song.free()
	s_a_p._clear_buses()


func test_get_neutral_effect_data() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	var param_track := {"Track1": {"fade_in": true}}
	assert_array(s_a_p.get_neutral_effect_data(param_track)).is_equal(
		s_a_p._get_track_effect_array("Track1", true)
	)
	s_a_p._clear_buses()


func test_update_volumes() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	s_a_p._tracks[TRACK_1].volume = -5.0
	s_a_p._tracks[TRACK_2].volume = 1.2
	s_a_p._tracks[SONG_ANIMATION_PLAYER].volume = 2.0
	s_a_p.update_volumes(100.0)
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_1]))).is_equal(
		-5.0
	)
	assert_str(str(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2])))).is_equal(
		"1.2"
	)
	# assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2]))).is_equal(
	# 	1.2
	# ) # for some reason assert_float is not working really well
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(SONG_ANIMATION_PLAYER))).is_equal(
		2.0
	)
	s_a_p._clear_buses()


func test_step_sequencer_emit_step() -> void:
	s_a_p.step_sequencer_emit_step("test")
	assert_signal(SignalManager).is_emitted("sequencer_step", ["test"])


func test_clear_buses() -> void:
	s_a_p._init_tracks()
	s_a_p._init_buses()
	assert_int(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_1])).is_not_equal(
		-1
	)
	assert_int(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2])).is_not_equal(
		-1
	)
	assert_int(AudioServer.get_bus_index(SONG_ANIMATION_PLAYER)).is_not_equal(-1)
	s_a_p._clear_buses()
	assert_int(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_1])).is_equal(-1)
	assert_int(AudioServer.get_bus_index("%s:%s" % [SONG_ANIMATION_PLAYER, TRACK_2])).is_equal(-1)
	assert_int(AudioServer.get_bus_index(SONG_ANIMATION_PLAYER)).is_equal(-1)


func test_create_bus() -> void:
	_test_create_default_bus()
	s_a_p._create_bus(TRACK_2, "Master")
	assert_int(AudioServer.get_bus_index(TRACK_2)).is_not_equal(-1)
	assert_bool(AudioServer.get_bus_effect(AudioServer.get_bus_index(TRACK_2), 0) is AudioEffectFilter).is_true()  # default filter
	assert_bool(AudioServer.get_bus_effect(AudioServer.get_bus_index(TRACK_2), 1) is AudioEffectFilter).is_true()  # custom filter


func _test_create_default_bus() -> void:
	AudioServer.add_bus()
	AudioServer.set_bus_name(AudioServer.bus_count - 1, "test_send_to")
	s_a_p._create_default_bus("test", "test_send_to")
	assert_int(AudioServer.get_bus_index("test")).is_not_equal(-1)
	assert_bool(AudioServer.get_bus_effect(AudioServer.get_bus_index("test"), s_a_p.bus_effects.filter) is AudioEffectFilter).is_true()
	assert_str(AudioServer.get_bus_send(AudioServer.get_bus_index("test"))).is_equal("test_send_to")
	AudioServer.remove_bus(AudioServer.get_bus_index("test"))
	AudioServer.remove_bus(AudioServer.get_bus_index("test_send_to"))


# not usefull to test _get_track_effect_array, it is a simple getter


func test_get_same_track() -> void:
	s_a_p._init_tracks()
	s_a_p.get_node(PATHS.track_1).playing = true
	s_a_p.get_node(PATHS.animation_player).play("anim_1")
	assert_str(s_a_p._get_same_track("anim_3")).is_equal(TRACK_1)


# TODO : hard to test
# func test_get_animation_time_from_track_time() -> void:
# 	s_a_p.get_node(PATHS.animation_player).play("anim_1")
# 	s_a_p.get_node(PATHS.animation_player).seek(0.1)
# 	assert_float(s_a_p._get_animation_time_from_track_time("anim_3", TRACK_1)).is_equal(0.2)


func test_get_track_play_times() -> void:
	s_a_p.get_node(PATHS.track_1).playing = true
	s_a_p.get_node(PATHS.track_2).playing = true
	var dict = s_a_p._get_track_play_times("anim_3", 0.3)
	assert_str(str(dict[TRACK_1])).is_equal("0.2")
	assert_str(str(dict[TRACK_2])).is_equal("0.3")
	# assert_dict(s_a_p._get_track_play_times("anim_3", 0.3)).is_equal({TRACK_1: 0.2, TRACK_2: 0.3}) # for some reason the dict and float compare fails, even though  values are the same


func test_remove_track_from_stop_queue() -> void:
	s_a_p._update_track_infos = {"animation": "anim_1", "fade_out": [[TRACK_1], [TRACK_1, TRACK_2]]}
	s_a_p._remove_track_from_stop_queue(TRACK_2)
	assert_bool(s_a_p._update_track_infos.fade_out.has(TRACK_2)).is_false()


func test_reset_bus() -> void:
	s_a_p._create_default_bus("test", "master")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("test"), -50.0)
	AudioServer.get_bus_effect(AudioServer.get_bus_index("test"), s_a_p.bus_effects.filter).cutoff_hz = 20.0
	s_a_p._reset_bus("test")
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("test"))).is_equal(0.0)
	assert_float(AudioServer.get_bus_effect(AudioServer.get_bus_index("test"), s_a_p.bus_effects.filter).cutoff_hz).is_equal(
		20000
	)
	AudioServer.remove_bus(AudioServer.get_bus_index("test"))


# TODO : Cannot test play time since _get_animation_time_from_track_time is returning weird values due to the test execution
func test_signal_on_parent_effect_done() -> void:
	s_a_p._update_track_infos = {"animation": "anim_3", "fade_out": []}
	s_a_p._init_tracks()
	s_a_p.get_node(PATHS.track_1).play()
	s_a_p._on_parent_effect_done()
	assert_str(s_a_p.get_node(PATHS.animation_player).current_animation).is_equal("anim_3")
	assert_bool(s_a_p.get_node(PATHS.animation_player).is_playing()).is_true()


func test_recur_check_clear_buses() -> void:
	assert_bool(s_a_p._recur_check_clear_buses(s_a_p)).is_true()
	s_a_p.get_node(PATHS.track_2).playing = true
	assert_bool(s_a_p._recur_check_clear_buses(s_a_p)).is_false()
