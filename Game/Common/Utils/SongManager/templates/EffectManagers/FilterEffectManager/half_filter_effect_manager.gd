extends FilterEffectManager
class_name HalfFilterEffectManager
# Filter effect manager, but only transitions to half of the filter

##### VARIABLES #####
#---- CONSTANTS -----
const FILTER_MID_LEVEL := 2000.0


##### PROTECTED METHODS #####
# adds an effect to the tween with the parameter specified
func _add_effect_to_tween(param: Dictionary):
	if param.fade_in:
		var _err = _tween.interpolate_property(
			param.object,
			param.interpolate_value,
			FILTER_MID_LEVEL,
			20000.0,
			TIME,
			Tween.TRANS_QUAD,
			Tween.EASE_IN
		)
	else:
		var _err = _tween.interpolate_property(
			param.object,
			param.interpolate_value,
			param.object[param.interpolate_value],
			FILTER_MID_LEVEL,
			TIME,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)
