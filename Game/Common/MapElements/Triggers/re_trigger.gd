extends Node
# A node that re-triggers a trigger signal into another one
# usefull to group signals together without altering its behaviours.

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal trigger

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties


##### SIGNAL MANAGEMENT #####
func use(_parameters) -> void:
	emit_signal("trigger")
