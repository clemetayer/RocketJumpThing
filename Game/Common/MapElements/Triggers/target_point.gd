extends Spatial
# a simple node that act as a target without any effect.

##### VARIABLES #####
#---- CONSTANTS -----
const TB_TARGET_POINT_MAPPER := [["targetname", "_targetname"]]

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _targetname: String


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	if _targetname != null:
		add_to_group(_targetname)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_TARGET_POINT_MAPPER)
