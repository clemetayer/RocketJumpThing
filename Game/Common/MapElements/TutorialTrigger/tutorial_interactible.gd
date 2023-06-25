extends Collidable
# TutorialInteractible

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const TB_TUTORIAL_INTERACTIBLE := [["key", "_key"], ["time", "_time"]]  # mapper for TrenchBroom parameters

#---- STANDARD -----
#==== PRIVATE ====
var _key: String
var _time: float

#==== ONREADY ====
onready var onready_path := {
	"collision_shape":$"CollisionShape"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_toggle_active(false)
	_connect_signals()

##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_TUTORIAL_INTERACTIBLE)

func _toggle_active(enabled : bool) -> void:
	visible = enabled
	onready_path.collision_shape.disabled = not enabled

func _connect_signals() -> void:
	DebugUtils.log_connect(self,self,"body_entered", "_on_area_tutorial_trigger_body_entered")
	DebugUtils.log_connect(SignalManager, self, SignalManager.TRIGGER_TUTORIAL, "_on_SignalManager_trigger_tutorial")

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_trigger_tutorial(key, _ptime) -> void:
	if key == _key:
		_toggle_active(true)

func _on_area_tutorial_trigger_body_entered(body):
	if FunctionUtils.is_player(body):
		SignalManager.emit_trigger_tutorial(_key, _time)
