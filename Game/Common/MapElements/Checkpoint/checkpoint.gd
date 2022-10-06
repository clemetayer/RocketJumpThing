tool
extends Area
class_name Checkpoint
# Checkpoint to respawn after a death

##### VARIABLES #####
#---- CONSTANTS -----
const TB_CHECKPOINT_MAPPER := [
	["spawn_position", "_spawn_position"], ["spawn_rotation", "_spawn_rotation"]
]  # mapper for TrenchBroom parameters
#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
var song_animation: String  # keeps the song animation name, to change the current song animation when respawning

#==== PRIVATE ====
var _spawn_position: Vector3
var _spawn_rotation: float


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()
	_set_TB_params()


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
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_CHECKPOINT_MAPPER)


func _connect_signals() -> void:
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


##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_Checkpoint_body_entered(body: Node):
	if FunctionUtils.is_player(body):
		SignalManager.emit_checkpoint_triggered(self)
		if (
			(song_animation == null or song_animation == "")
			and StandardSongManager.get_current() != null
		):
			song_animation = StandardSongManager.get_current().ANIMATION
