tool
extends Area
class_name Checkpoint
# Checkpoint to respawn after a death

##### VARIABLES #####
#---- EXPORTS -----
export (Dictionary) var properties setget set_properties

#---- STANDARD -----
#==== PRIVATE ====
var _spawn_position: Vector3


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if connect("body_entered", self, "_on_Checkpoint_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_Checkpoint_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


##### PUBLIC METHODS #####
func get_checkpoint() -> Checkpoint:
	return self


func get_spawn_point() -> Vector3:
	if _spawn_position != null and _spawn_position != Vector3(0, 0, 0):
		return get_parent().transform.origin + _spawn_position
	return get_parent().transform.origin + self.transform.origin


##### PROTECTED METHODS #####
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'spawn_position' in properties:
		_spawn_position = properties.spawn_position


##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_Checkpoint_body_entered(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_checkpoint_triggered(self)
