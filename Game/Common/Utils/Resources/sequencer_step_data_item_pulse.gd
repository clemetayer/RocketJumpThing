tool
extends SequencerStepDataItem
class_name SequencerStepDataItemPulse
# Step data for the "pulse" mode (like tween, but in and out)

##### VARIABLES #####
#---- CONSTANTS -----
const PULSE_VALUES := {  # Standard value to set in VALUES
	"initial_value": null,
	"final_value": null,
	"duration": {"in": 0.0, "out": 0.0},
	"transition_type":
	{
		"in": GlobalConstants.TWEEN_TRANSITION_TYPES.LINEAR,
		"out": GlobalConstants.TWEEN_TRANSITION_TYPES.LINEAR
	},
	"ease_type":
	{"in": GlobalConstants.TWEEN_EASE_TYPES.IN, "out": GlobalConstants.TWEEN_EASE_TYPES.IN},
	"delay": {"in": 0.0, "out": 0.0}
}


##### PUBLIC METHODS #####
# mandatory method, process step on the step_sequencer
# by default, just assigns the variable to the item
func step(step_sequencer: Node) -> void:
	var tweens = _init_tweens(step_sequencer, VARPATH)
	RuntimeUtils.add_child(tweens[0])
	RuntimeUtils.add_child(tweens[1])
	DebugUtils.log_tween_start(tweens[0])
	yield(tweens[0], "tween_all_completed")
	DebugUtils.log_tween_start(tweens[1])
	yield(tweens[1], "tween_all_completed")
	tweens[0].queue_free()
	tweens[1].queue_free()


##### PROTECTED METHODS #####
# used to override the standard dictionary
func _get_values() -> Dictionary:
	if Engine.is_editor_hint():
		var values = VALUES
		if values == null:
			values = PULSE_VALUES
		return values
	else:
		return VALUES


func _init_tweens(step_sequencer: Node, variable_path: String) -> Array:
	var tween_in := Tween.new()
	var tween_out := Tween.new()
	DebugUtils.log_tween_interpolate_property(
		tween_in,
		step_sequencer,
		variable_path,
		VALUES.initial_value,
		VALUES.final_value,
		VALUES.duration.in,
		VALUES.transition_type.in,
		VALUES.ease_type.in,
		VALUES.delay.in
	)
	DebugUtils.log_tween_interpolate_property(
		tween_out,
		step_sequencer,
		variable_path,
		VALUES.final_value,
		VALUES.initial_value,
		VALUES.duration.out,
		VALUES.transition_type.out,
		VALUES.ease_type.out,
		VALUES.delay.out
	)
	return [tween_in, tween_out]
