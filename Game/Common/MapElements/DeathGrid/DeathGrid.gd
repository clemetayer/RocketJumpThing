extends Area
class_name DeathGrid


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if connect("body_exited", self, "_on_body_exited") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% ["body_exited", "_on_body_exited", DebugUtils.print_stack_trace(get_stack())]
			)
		)


##### SIGNAL MANAGEMENT #####
func _on_body_exited(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_respawn_player_on_last_cp()
