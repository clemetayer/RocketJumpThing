extends Node
# A script to keep track of levels and level lists

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5
const LOADING_SCREEN_PATH := "res://Game/Common/Menus/LoadingScreen/loading_screen.tscn"
const MAIN_MENU_PATH := "res://Game/Common/Menus/MainMenu/main_menu.tscn"
const CREDITS_PATH := "res://Game/Common/Menus/EndGame/end_game.tscn"

#---- STANDARD -----
#==== PUBLIC ====
var paused := false

#==== PRIVATE ====
var _current_level_data: LevelsData
var _current_level_idx := 0
var _current_scene_instance: Node = null  # instance of the current scene


##### PUBLIC METHODS #####
func get_current_level_idx() -> int:
	return _current_level_idx


func has_next_level() -> bool:
	return _current_level_data != null and _current_level_data.has_next_level(_current_level_idx)


func has_previous_level() -> bool:
	return (
		_current_level_data != null and _current_level_data.has_previous_level(_current_level_idx)
	)


func enable_next_level() -> void:
	if _current_level_data != null and _current_level_data.has_next_level(_current_level_idx):
		_current_level_data.get_level(_current_level_idx + 1).UNLOCKED = true
		RuntimeUtils.save_levels_data()


func load_main_menu() -> void:
	LoadingScreen.LEVEL_NAME = tr(TranslationKeys.MAIN_MENU)
	_goto_scene(MAIN_MENU_PATH, Input.MOUSE_MODE_VISIBLE)
	_current_level_data = null
	_current_level_idx = 0
	_current_scene_instance = null


func load_end() -> void:
	LoadingScreen.LEVEL_NAME = tr(TranslationKeys.MAIN_MENU)
	if get_tree() != null and get_tree().change_scene(CREDITS_PATH) != OK:
		DebugUtils.log_stacktrace(
			"Error while changing scene to %s" % CREDITS_PATH, DebugUtils.LOG_LEVEL.error
		)
	RuntimeUtils.save_levels_data()
	MenuNavigator.toggle_pause_enabled(false)
	_current_level_data = null
	_current_level_idx = 0
	_current_scene_instance = null


func load_level(levels: LevelsData, idx: int = 0) -> void:
	_switch_to_game_scene(levels, idx, Input.MOUSE_MODE_CAPTURED)


func previous_level() -> void:
	if _current_level_data != null and _current_level_data.has_previous_level(_current_level_idx):
		_switch_to_game_scene(
			_current_level_data, _current_level_idx - 1, Input.MOUSE_MODE_CAPTURED
		)


func next_level() -> void:
	if _current_level_data != null and _current_level_data.has_next_level(_current_level_idx):
		_switch_to_game_scene(
			_current_level_data, _current_level_idx + 1, Input.MOUSE_MODE_CAPTURED
		)


func reload_current() -> void:
	_switch_to_game_scene(_current_level_data, _current_level_idx, Input.MOUSE_MODE_CAPTURED)


func get_current() -> Node:
	# if _current_scene_instance != null:
	# 	return _current_scene_instance
	# return get_tree().get_current_scene() # for single scene tests, mostly
	return get_tree().get_current_scene()


func pause() -> void:
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			FunctionUtils.create_filter_auto_effect(FADE_IN_TIME),
			{StandardSongManager.get_current().name: {"fade_in": false}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	paused = true


# by default, shows the mouse.
func unpause(input_mode: int = Input.MOUSE_MODE_VISIBLE) -> void:
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			FunctionUtils.create_filter_auto_effect(FADE_IN_TIME),
			{StandardSongManager.get_current().name: {"fade_in": true}}
		)
	Input.set_mouse_mode(input_mode)
	get_tree().paused = false
	paused = false


##### PROTECTED METHODS #####
func _switch_to_game_scene(
	levels: LevelsData, idx: int, input_mode: int = Input.MOUSE_MODE_VISIBLE
) -> void:
	if levels != null and levels.check_has_level(idx):
		var current_level = levels.get_level(idx)
		if current_level != null:
			if levels != _current_level_data:
				_current_level_data = levels
			LoadingScreen.LEVEL_NAME = current_level.NAME
			_goto_scene(current_level.SCENE_PATH, input_mode)
			_current_level_idx = idx


func _goto_scene(path: String, input_mode: int = Input.MOUSE_MODE_VISIBLE) -> void:
	# call_deferred("deferred_goto_scene", path)
	LoadingScreen.appear()
	yield(LoadingScreen, LoadingScreen.APPEAR_FINISHED_SIGNAL_NAME)
	if get_tree() != null and get_tree().change_scene(path) != OK:
		DebugUtils.log_stacktrace(
			"Error while changing scene to %s" % path, DebugUtils.LOG_LEVEL.error
		)
	pause()
	LoadingScreen.disappear()
	yield(LoadingScreen, LoadingScreen.DISAPPEAR_FINISHED_SIGNAL_NAME)
	unpause(input_mode)

# func deferred_goto_scene(path: String) -> void:
# 	if get_tree() != null:
# 		var root = get_tree().get_root()
# 		var current_scene = root.get_child(root.get_child_count() - 1)
# 		current_scene.free()
# 		var new_scene = load(path).instance()
# 		_current_scene_instance = new_scene
# 		get_tree().get_root().call_deferred("add_child", new_scene)
# 		get_tree().set_current_scene(new_scene)
