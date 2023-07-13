tool
extends Resource
class_name LevelsData
# Usefull data for every level

##### VARIABLES #####
#---- CONSTANTS -----
const SAVE_PATH := "user://levels_data.tres"

#---- EXPORTS -----
export(Array) var LEVELS setget , _get_levels

##### PUBLIC METHODS #####
func save() -> void:
	DebugUtils.log_save_resource(self, SAVE_PATH)

func has_next_level(cur_idx : int) -> bool:
	return check_has_level(cur_idx + 1)

func has_previous_level(cur_idx : int) -> bool:
	return check_has_level(cur_idx - 1)

func check_has_level(idx: int) -> bool:
	var valid = true
	if LEVELS == null or LEVELS.size() <= 0:
		valid = false
		Logger.warn(
			"levels list is empty or null, at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	if idx < 0:
		valid = false
		Logger.error("level index is negative, at %s" % [DebugUtils.print_stack_trace(get_stack())])
	if idx >= LEVELS.size():
		valid = false
		Logger.warn(
			(
				"can't load level index %d of %s, that has a size of %d, at %s"
				% [idx, LEVELS, LEVELS.size(), DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if valid and not LEVELS[idx] is LevelData:
		valid = false
		Logger.warn(
			(
				"%s is not of type LevelData, at %s"
				% [LEVELS[idx], DebugUtils.print_stack_trace(get_stack())]
			)
		)
	return valid

func get_level(idx : int) -> LevelData:
	if check_has_level(idx):
		return LEVELS[idx]
	return null

##### PROTECTED METHODS #####
func _get_levels() -> Array:
	if Engine.is_editor_hint():
		var levels = LEVELS
		for level_idx in range(levels.size()):
			if levels[level_idx] == null:
				levels[level_idx] = LevelData.new()
				LEVELS = levels
		return levels
	else:
		return LEVELS
