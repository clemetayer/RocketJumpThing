extends Resource
class_name MoverTravelData

##### VARIABLES #####
#---- EXPORTS -----
export(Vector3) var POSITION = Vector3.ZERO
export(Vector3) var ROTATION_DEGREES = Vector3.ZERO
export(float) var TRAVEL_TIME = 0.0
export(float) var WAIT_TIME = 0.0
export(GlobalConstants.TWEEN_TRANSITION_TYPES) var TRANSITION_TYPE = GlobalConstants.TWEEN_TRANSITION_TYPES.TRANS_SINE
export(GlobalConstants.TWEEN_EASE_TYPES) var EASE_TYPE = GlobalConstants.TWEEN_EASE_TYPES.IN
