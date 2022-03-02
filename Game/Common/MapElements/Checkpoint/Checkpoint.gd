tool
extends Area
class_name Checkpoint
# Checkpoint to respawn after a death

# TODO : look at the correct direction on respawn

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties setget set_properties

#---- STANDARD -----
#==== PRIVATE ====
var _spawn_position: Vector3
var _spawn_rotation: float


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
		return global_transform.origin + _spawn_position
	return global_transform.origin


func get_spawn_rotation() -> float:
	if _spawn_rotation != null:
		return _spawn_rotation
	return 0.0


##### PROTECTED METHODS #####
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if "spawn_position" in properties:
		_spawn_position = properties.spawn_position
	if "spawn_rotation" in properties:
		_spawn_rotation = properties.spawn_rotation


##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_Checkpoint_body_entered(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_checkpoint_triggered(self)
