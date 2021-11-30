extends Area
class_name Checkpoint
# Checkpoint to respawn after a death

##### VARIABLES #####
#---- EXPORTS -----
# TODO : maybe create an export to set the box size on ready


##### PUBLIC METHODS #####
func get_spawn_point() -> Vector3:
	return get_parent().transform.origin + self.transform.origin


##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_Checkpoint_body_entered(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_checkpoint_triggered(self)
