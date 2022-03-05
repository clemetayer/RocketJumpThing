extends Area
# End point area of the map


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	FunctionUtils.log_connect(self, self, "body_entered", "_on_EndPoint_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_EndPoint_body_entered(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_end_reached()
