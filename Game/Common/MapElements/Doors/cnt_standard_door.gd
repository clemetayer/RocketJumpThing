extends StandardDoor
# A standard door, but that opens only after a cnt amount of times

##### VARIABLES #####
#---- CONSTANTS -----
const TB_CNT_STANDARD_DOOR_MAPPER := [["cnt", "_cnt"]]

#---- STANDARD -----
#==== PRIVATE ====
var _cnt: int


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_CNT_STANDARD_DOOR_MAPPER
	)


##### SIGNAL MANAGEMENT #####
func use() -> void:
	if _cnt != null:
		_cnt -= 1
		if _cnt <= 0:
			.use()
