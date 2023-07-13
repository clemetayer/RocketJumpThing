extends Area
# End point area of the map


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_add_to_end_point_group()
	_connect_signals()


##### PROTECTED METHODS #####
func _save_level_data() -> void:
	var current_idx = ScenesManager.get_current_level_idx()
	if _is_best_time(RuntimeUtils.levels_data.get_level(current_idx)):
		RuntimeUtils.levels_data.get_level(current_idx).BEST_TIME = (
			VariableManager.chronometer.level
		)
	ScenesManager.enable_next_level()
	RuntimeUtils.levels_data.save()


# adds the end point to the end_point group
func _add_to_end_point_group() -> void:
	add_to_group("end_point")


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_EndPoint_body_entered")


func _is_best_time(level_data: LevelData) -> bool:
	if level_data != null:
		return VariableManager.chronometer.level < level_data.BEST_TIME
	Logger.error("Level data is null, at %s" % [DebugUtils.print_stack_trace(get_stack())])
	return false


##### SIGNAL MANAGEMENT #####
func _on_EndPoint_body_entered(body: Node):
	if FunctionUtils.is_player(body):
		SignalManager.emit_end_reached()
		_save_level_data()
		VariableManager.scene_unloading = true
