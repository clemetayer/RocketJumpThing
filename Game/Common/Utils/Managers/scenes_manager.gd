extends Node
# A script to keep track of levels and level lists

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const LEVELS_JSON_PATH := "res://scenes.json"
const GAME_SCENES := "game_scenes"
const MAIN_MENU := "main_menu"

#---- STANDARD -----
#==== PUBLIC ====
# TODO : use a resource
#{
#	"list1":[
#		"level1 path",
#		"level2 path",
#		...
#	],
#	...
#}
var levels = {}  # Dictionnary of levels

#==== PRIVATE ====
var _current_level_list: String
var _current_level_idx := 0
var _current_scene_instance: Node = null  # instance of the current scene


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_load_levels_json_data()


##### PUBLIC METHODS #####
func has_next_level() -> bool:
	return (
		(_current_level_list != null or _current_level_list != "")
		and levels[GAME_SCENES].has(_current_level_list)
		and _current_level_idx < levels[GAME_SCENES][_current_level_list].size() - 1
	)


func has_previous_level() -> bool:
	return (
		(_current_level_list != null or _current_level_list != "")
		and levels[GAME_SCENES].has(_current_level_list)
		and _current_level_idx > 0
	)


func load_main_menu() -> void:
	_goto_scene(levels[MAIN_MENU])
	_current_level_list = ""  # because it is a "special" list
	_current_level_idx = 0
	_current_scene_instance = null


func load_level(name: String, idx: int = 0) -> void:
	_switch_to_game_scene(name, idx)


func previous_level() -> void:
	_switch_to_game_scene(_current_level_list, _current_level_idx - 1)


func next_level() -> void:
	_switch_to_game_scene(_current_level_list, _current_level_idx + 1)


func reload_current() -> void:
	_switch_to_game_scene(_current_level_list, _current_level_idx)


func get_current() -> Node:
	# if _current_scene_instance != null:
	# 	return _current_scene_instance
	# return get_tree().get_current_scene() # for single scene tests, mostly
	return get_tree().get_current_scene()


func load_end() -> void:
	# TODO : implement this
	pass


##### PROTECTED METHODS #####
func _load_levels_json_data() -> void:
	levels = FunctionUtils.load_json(LEVELS_JSON_PATH)


func _switch_to_game_scene(name: String, idx: int) -> void:
	if levels[GAME_SCENES].has(name):
		if levels[GAME_SCENES][name].size() > 0:
			if idx < levels[GAME_SCENES][name].size() and idx >= 0:
				_goto_scene(levels[GAME_SCENES][name][idx])
				_current_level_list = name
				_current_level_idx = idx
			else:
				Logger.error(
					(
						"attempted to load level index %d of levels[%s], but has size %d at %s"
						% [
							idx,
							name,
							levels[GAME_SCENES][name].size(),
							DebugUtils.print_stack_trace(get_stack())
						]
					)
				)
		else:
			Logger.error(
				"levels[%s] is size 0 at %s" % [name, DebugUtils.print_stack_trace(get_stack())]
			)
	else:
		Logger.error(
			(
				"levels does not have the level list %s at %s"
				% [name, DebugUtils.print_stack_trace(get_stack())]
			)
		)


func _goto_scene(path: String) -> void:
	# call_deferred("deferred_goto_scene", path)
	if get_tree() != null and get_tree().change_scene(path) != OK:
		Logger.error(
			(
				"Error while changing scene to %s at %s"
				% [path, DebugUtils.print_stack_trace(get_stack())]
			)
		)

# func deferred_goto_scene(path: String) -> void:
# 	if get_tree() != null:
# 		var root = get_tree().get_root()
# 		var current_scene = root.get_child(root.get_child_count() - 1)
# 		current_scene.free()
# 		var new_scene = load(path).instance()
# 		_current_scene_instance = new_scene
# 		get_tree().get_root().call_deferred("add_child", new_scene)
# 		get_tree().set_current_scene(new_scene)
