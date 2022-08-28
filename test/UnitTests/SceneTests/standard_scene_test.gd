# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name StandardSceneTest
# A test template for all scenes (as game levels) in general

##### VARIABLES #####
var scene_path: String  # path to the scene to test
var scene_instance: Spatial  # scene instance to test


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = scene_path
	scene_instance = load(scene_path).instance()
	init_signal_manager()
	init_variable_manager()
	init_song_manager()
	.before()


func after():
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
	assert_str(str(scene_instance.PATHS.player)).is_not_equal("")
	assert_int(global_utilities.count_in_group_in_children(scene_instance, "player", true)).is_equal(
		1
	)


# start point in scene
func _test_start_in_scene() -> void:
	assert_str(str(scene_instance.PATHS.start_point)).is_not_equal("")
	assert_int(global_utilities.count_in_group_in_children(scene_instance, "start_point", true)).is_equal(
		1
	)


# end area in scene
func _test_end_in_scene() -> void:
	assert_int(global_utilities.count_in_group_in_children(scene_instance, "end_point", true)).is_equal(
		1
	)


# tests the pause
func test_pause() -> void:
	scene_instance._init_pause()
	assert_bool(scene_instance.variable_manager.pause_enabled).is_true()


# tests the end level
func test_end_level() -> void:
	scene_instance._init_end_level()
	assert_bool(scene_instance.variable_manager.end_level_enabled).is_true()


# tests the signal connections
func test_signal_connections() -> void:
	scene_instance._connect_autoload_signals()
	assert_bool(scene_instance.signal_manager.is_connected("checkpoint_triggered", scene_instance, "_on_checkpoint_triggered")).is_true()
	assert_bool(scene_instance.signal_manager.is_connected("respawn_player_on_last_cp", scene_instance, "_on_respawn_player_on_last_cp")).is_true()


# tests the restart method
func test_restart() -> void:
	var last_cp_test = Checkpoint.new()
	var start_point = scene_instance.get_node(scene_instance.PATHS.start_point)
	var player = scene_instance.get_node(scene_instance.PATHS.player)
	scene_instance._last_cp = last_cp_test
	scene_instance._restart()
	assert_signal(scene_instance.signal_manager).is_emitted("start_level_chronometer")
	assert_vector3(player.transform.origin).is_equal(start_point.get_spawn_point())
	assert_float(player.rotation_degrees.y).is_equal(start_point.get_spawn_rotation())
	assert_vector3(player.vel).is_equal(Vector3.ZERO)
	assert_object(scene_instance._last_cp).is_equal(start_point)
	last_cp_test.free()
	var song = scene_instance.song_manager._queue.pop_back()
	song.song.queue_free()
	song.effect.queue_free()


# tests the input
# TODO : causes performance issues on tests, removed it for the moment
# func test_inputs() -> void:
# 	var runner := scene_runner(scene_path)
# 	runner.simulate_key_pressed(InputMap.get_action_list("restart_last_cp")[0].scancode)
# 	assert_signal(scene_instance.signal_manager).is_emitted("respawn_player_on_last_cp")
# 	runner.simulate_key_pressed(InputMap.get_action_list("restart")[0].scancode)
# 	assert_signal(scene_instance.signal_manager).is_emitted("respawn_player_on_last_cp")


# tests the respawn on last cp (not start)
func test_respawn_player_on_last_cp() -> void:
	scene_instance.song_manager._queue = []
	var last_cp_test = Checkpoint.new()
	last_cp_test._spawn_position = Vector3.ONE
	last_cp_test._spawn_rotation = 1.0
	last_cp_test.song_animation = "test"
	var player = scene_instance.get_node(scene_instance.PATHS.player)
	scene_instance._last_cp = last_cp_test
	scene_instance._on_respawn_player_on_last_cp()
	assert_signal(scene_instance.signal_manager).is_not_emitted("start_level_chronometer")
	assert_vector3(player.transform.origin).is_equal(last_cp_test.get_spawn_point())
	assert_float(player.rotation_degrees.y).is_equal(last_cp_test.get_spawn_rotation())
	assert_vector3(player.vel).is_equal(Vector3.ZERO)
	assert_array(scene_instance.song_manager._queue).is_not_empty()
	last_cp_test.free()
	var song = scene_instance.song_manager._queue.pop_back()
	song.song.queue_free()
	song.effect.queue_free()


#---- UTILITIES -----
func init_signal_manager() -> void:
	scene_instance.signal_manager = SignalManagerMock.new()


func init_variable_manager() -> void:
	scene_instance.variable_manager = VariableManagerMock.new()


func init_song_manager() -> void:
	scene_instance.song_manager = StandardSongManagerMock.new()
