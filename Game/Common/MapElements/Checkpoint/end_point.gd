extends Area
# End point area of the map


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_add_to_end_point_group()
	_connect_signals()


##### PROTECTED METHODS #####
# adds the end point to the end_point group
func _add_to_end_point_group() -> void:
	add_to_group("end_point")


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_EndPoint_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_EndPoint_body_entered(body: Node):
	if FunctionUtils.is_player(body):
		VariableManager.scene_unloading = true
		SignalManager.emit_end_reached()
