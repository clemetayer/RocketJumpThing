extends Collidable
# Portal script

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal trigger(element)

##### VARIABLES #####
#---- CONSTANTS -----
const TB_PORTAL_MAPPER := [["id", "id"], ["mangle", "_mangle"], ["scale", "_scale"]]  # mapper for TrenchBroom parameters
const OFFSET := 2.0  # offset to avoid making the player constantly triggering the portal by spawning on its center

#---- STANDARD -----
#==== PRIVATE ====
var id := ""  # portal id
var _mangle := Vector3.ZERO  # trenchbroom angles
var _scale := 1.0  # scale of the portal

#==== ONREADY ====
onready var onready_paths := {
	"forward_pos": $"ForwardPos", "mesh": $"PortalMesh", "collision": $"PortalCollision"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


func _ready_func() -> void:
	._ready_func()
	rotation_degrees = _mangle
	scale = Vector3.ONE * _scale


##### PUBLIC METHODS #####
# returns the global vector of the portal
func get_global_forward_vector() -> Vector3:
	return onready_paths.forward_pos.global_transform.origin - global_transform.origin


func get_rotation_degrees() -> Vector3:
	return _mangle


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_PORTAL_MAPPER)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	DebugUtils.log_connect(self, self, "area_entered", "_on_area_entered")


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_portal_compatible(body):
		emit_signal("trigger", body)


func _on_area_entered(area: Node) -> void:
	if FunctionUtils.is_portal_compatible(area):
		emit_signal("trigger", area)


#==== Qodot =====
func use(element: Node) -> void:
	element.call(FunctionUtils.PORTAL_PROCESS_METHOD_NAME, self)
