extends Collidable
# An area to enable or disable some of the player's abilities

##### VARIABLES #####
#---- CONSTANTS -----
const TB_AREA_ENABLE_MAPPER := [["slide", "_slide"], ["rockets", "_rockets"]]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _slide: bool
var _rockets: bool


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_AREA_ENABLE_MAPPER)


func _connect_signals() -> void:
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.toggle_ability("slide", _slide)
		body.toggle_ability("rockets", _rockets)
