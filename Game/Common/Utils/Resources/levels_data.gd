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
		DebugUtils.log_stacktrace(
			"levels list is empty or null", DebugUtils.LOG_LEVEL.warn
		)
	if idx < 0:
		valid = false
		DebugUtils.log_stacktrace(
			"level index is negative", DebugUtils.LOG_LEVEL.error
		)
	if idx >= LEVELS.size():
		valid = false
		DebugUtils.log_stacktrace(
			"can't load level index %d of %s, that has a size of %d" % [idx, LEVELS, LEVELS.size()], DebugUtils.LOG_LEVEL.warn
		)
	if valid and not LEVELS[idx] is LevelData:
		valid = false
		DebugUtils.log_stacktrace(
			"%s is not of type LevelData" % LEVELS[idx], DebugUtils.LOG_LEVEL.warn
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
