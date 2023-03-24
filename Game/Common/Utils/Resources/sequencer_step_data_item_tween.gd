tool
extends SequencerStepDataItem
class_name SequencerStepDataItemTween
# Step data for the "tween" mode

##### VARIABLES #####
#---- CONSTANTS -----
const TWEEN_VALUES := {  # Standard value to set in VALUES
	"initial_value": null,
	"final_value": null,
	"duration": 0.0,
	"transition_type": GlobalConstants.TWEEN_TRANSITION_TYPES.LINEAR,
	"ease_type": GlobalConstants.TWEEN_EASE_TYPES.IN,
	"delay": 0.0
}


##### PUBLIC METHODS #####
# mandatory method, process step on the step_sequencer
# by default, just assigns the variable to the item
func step(step_sequencer: Node) -> void:
	var tween := _init_tween(step_sequencer, VARPATH)
	RuntimeUtils.add_child(tween)  # adds the tween to runtime utils since this is a resource
	DebugUtils.log_tween_start(tween)
	yield(tween, "tween_all_completed")
	tween.queue_free()


##### PROTECTED METHODS #####
# used to override the standard dictionary
func _get_values() -> Dictionary:
	if Engine.is_editor_hint():
		var values = VALUES
		if values == null:
			values = TWEEN_VALUES
		return values
	else:
		return VALUES


func _init_tween(step_sequencer: Node, variable_path: String) -> Tween:
	var tween := Tween.new()
	DebugUtils.log_tween_interpolate_property(
		tween,
		step_sequencer,
		variable_path,
		VALUES.initial_value,
		VALUES.final_value,
		VALUES.duration,
		VALUES.transition_type,
		VALUES.ease_type,
		VALUES.delay
	)
	return tween
