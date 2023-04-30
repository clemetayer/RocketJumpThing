extends Area
# Trigger an animation of The Entity

##### VARIABLES #####
#---- CONSTANTS -----
const TB_TRIGGER_ENTITY_ANIMATION_MAPPER := [["animation", "_animation"]]  # mapper for TrenchBroom parameters

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _animation: String


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_TRIGGER_ENTITY_ANIMATION_MAPPER
	)


func _connect_signals():
	DebugUtils.log_connect(self, self, "body_entered", "_on_TriggerEntityAnimation_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_TriggerEntityAnimation_body_entered(body) -> void:
	if FunctionUtils.is_player(body):
		SignalManager.emit_trigger_entity_animation(_animation)
