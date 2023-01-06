extends Collidable
# Portal script

##### VARIABLES #####
#---- CONSTANTS -----
const TB_PORTAL_MAPPER := [["id", "id"], ["mangle", "_mangle"]]  # mapper for TrenchBroom parameters
const OFFSET := 2.0  # offset to avoid making the player constantly triggering the portal by spawning on its center

#---- STANDARD -----
#==== PRIVATE ====
var id := ""  # portal id
var _mangle := Vector3.ZERO  # trenchbroom angles

#==== ONREADY ====
onready var onready_paths := {"forward_pos": $"ForwardPos"}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


func _ready_func() -> void:
	._ready_func()
	rotation_degrees = _mangle


##### PUBLIC METHODS #####
# returns the global vector of the portal
func get_global_forward_vector() -> Vector3:
	return onready_paths.forward_pos.global_transform.origin - global_transform.origin


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_PORTAL_MAPPER)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	DebugUtils.log_connect(self, self, "area_entered", "_on_area_entered")
	DebugUtils.log_connect(SignalManager, self, SignalManager.PORTAL_ENTERED, "_on_portal_entered")


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_portal_compatible(body):
		SignalManager.emit_portal_entered(self, body)


func _on_area_entered(area: Node) -> void:
	if FunctionUtils.is_portal_compatible(area):
		SignalManager.emit_portal_entered(self, area)


func _on_portal_entered(entered_portal: Node, element: Node) -> void:
	if entered_portal.id == id and entered_portal != self:
		element.call(FunctionUtils.PORTAL_PROCESS_METHOD_NAME, self)
