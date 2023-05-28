extends BreakableLink
# special behaviour for a green breakable link

##### VARIABLES #####
#---- CONSTANTS -----
const TB_BREAKABLE_LINK_GREEN_MAPPER := [["target", "_target"]]

#---- STANDARD -----
#==== PRIVATE ====
var _target: String


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()


##### PUBLIC METHODS #####
# returns the target group name
func get_target_group_name() -> String:
	return _target if _target != null else ""


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_BREAKABLE_LINK_GREEN_MAPPER
	)
