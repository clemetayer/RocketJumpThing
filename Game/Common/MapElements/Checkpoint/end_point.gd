extends Area
class_name EndPoint
# End point area of the map


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	add_to_group("end_point")
	FunctionUtils.log_connect(self, self, "body_entered", "_on_EndPoint_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_EndPoint_body_entered(body: Node):
	if body.is_in_group("player"):
		VariableManager.scene_unloading = true
		SignalManager.emit_end_reached()
