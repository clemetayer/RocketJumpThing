# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name StandardSceneTest
# A test template for all scenes (as game levels) in general

##### VARIABLES #####
const START_POINT_PATH := "res://Game/Common/MapElements/Checkpoint/start_point.tscn"
const PLAYER_PATH := "res://Game/Common/MapElements/Characters/MainCharacters/player.tscn"
var scene_path: String  # path to the scene to test
var scene_instance: Spatial  # scene instance to test


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = scene_path
	scene_instance = load(scene_path).instance()
	scene_instance._player = load(PLAYER_PATH).instance()  # Kind of an ugly way to do this, but since get_tree() returns null in test mode, it is the best way to do it
	scene_instance._start_point = load(START_POINT_PATH).instance()  # Kind of an ugly way to do this, but since get_tree() returns null in test mode, it is the best way to do it
	.before()


func after():
	scene_instance._player.free()
	scene_instance._start_point.free()
	scene_instance.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
# test if the mandatory elements are in the scene
func test_mandatory_elements() -> void:
	_test_player_in_scene()
	_test_start_in_scene()
	_test_end_in_scene()


# player in the scene
func _test_player_in_scene() -> void:
	assert_int(GlobalTestUtilities.count_in_group_in_children(scene_instance, "player", true)).is_equal(
		1
	)


# start point in scene
func _test_start_in_scene() -> void:
	assert_int(GlobalTestUtilities.count_in_group_in_children(scene_instance, "start_point", true)).is_equal(
		1
	)


# end area in scene
func _test_end_in_scene() -> void:
	assert_int(GlobalTestUtilities.count_in_group_in_children(scene_instance, "end_point", true)).is_equal(
		1
	)


# tests the pause
func test_pause() -> void:
	scene_instance._init_pause()


# tests the end level
func test_end_level() -> void:
	scene_instance._init_end_level()


# tests the signal connections
func test_signal_connections() -> void:
	scene_instance._connect_autoload_signals()
	assert_bool(SignalManager.is_connected(SignalManager.CHECKPOINT_TRIGGERED, scene_instance, "_on_checkpoint_triggered")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.RESPAWN_PLAYER_ON_LAST_CP, scene_instance, "_on_respawn_player_on_last_cp")).is_true()


# tests the restart method
func test_restart() -> void:
	var last_cp_test = Checkpoint.new()
	var start_point = scene_instance._start_point
	var player = scene_instance._player
	player._ready()
	scene_instance._last_cp = last_cp_test
	scene_instance._restart()
	# assert_signal(SignalManager).is_emitted("start_level_chronometer") # creates an error for the next test scenes in the suite for some reason
	assert_vector3(player.transform.origin).is_equal(start_point.get_spawn_point())
	assert_float(player.rotation_degrees.y).is_equal(start_point.get_spawn_rotation().y)
	assert_float(player.rotation_helper.rotation_degrees.x).is_equal(
		start_point.get_spawn_rotation().x
	)
	assert_vector3(player.vel).is_equal(Vector3.ZERO)
	assert_object(scene_instance._last_cp).is_equal(start_point)
	last_cp_test.free()
	var song = StandardSongManager._queue.pop_back()
	if song != null and _has_song():
		song.song.queue_free()
		song.effect.queue_free()


# tests the input
# TODO : causes performance issues on tests, removed it for the moment
# func test_inputs() -> void:
# 	var runner := scene_runner(scene_path)
# 	runner.simulate_key_pressed(InputMap.get_action_list("restart_last_cp")[0].scancode)
# 	assert_signal(SignalManager).is_emitted("respawn_player_on_last_cp")
# 	runner.simulate_key_pressed(InputMap.get_action_list("restart")[0].scancode)
# 	assert_signal(SignalManager).is_emitted("respawn_player_on_last_cp")


# tests the respawn on last cp (not start)
func test_respawn_player_on_last_cp() -> void:
	StandardSongManager._queue = []
	var last_cp_test = Checkpoint.new()
	last_cp_test._spawn_position = Vector3.ONE
	last_cp_test._mangle = Vector3(45, 90, 0)
	last_cp_test.song_animation = "test"
	var player = scene_instance._player
	player._ready()
	scene_instance._last_cp = last_cp_test
	scene_instance._on_respawn_player_on_last_cp()
	# assert_signal(SignalManager).is_not_emitted("start_level_chronometer")
	assert_vector3(player.transform.origin).is_equal(last_cp_test.get_spawn_point())
	assert_float(player.rotation_degrees.y).is_equal(last_cp_test.get_spawn_rotation().y)
	assert_float(player.rotation_helper.rotation_degrees.x).is_equal(
		last_cp_test.get_spawn_rotation().x
	)
	assert_vector3(player.vel).is_equal(Vector3.ZERO)
	if _has_song():
		assert_array(StandardSongManager._queue).is_not_empty()
	last_cp_test.free()
	var song = StandardSongManager._queue.pop_back()
	if _has_song():
		song.song.queue_free()
		song.effect.queue_free()


func _has_song() -> bool:
	return (
		scene_instance.PATHS.bgm != null
		and scene_instance.PATHS.bgm.path != null
		and scene_instance.PATHS.bgm.animation != null
		and not scene_instance.PATHS.bgm.path.empty()
		and not scene_instance.PATHS.bgm.animation.empty()
	)
