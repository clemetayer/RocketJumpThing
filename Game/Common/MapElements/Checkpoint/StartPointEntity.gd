tool
extends QodotEntity
# Entity for start point


##### PUBLIC METHODS #####
func get_checkpoint() -> Checkpoint:
	var cp: Checkpoint = $StartPoint
	return cp
