tool
extends Resource
class_name SequencerStepDataItem
# Base class for step sequencer items

##### VARIABLES #####
#---- CONSTANTS -----
const STANDARD_VALUES := {"value": null}  # Standard value to set in VALUES

#---- EXPORTS -----
export(String) var VARPATH  # NodePath to the desired variable, as a String
# Convenient way to pass standard objects to exports (no way to export a Variant)
export(Dictionary) var VALUES = null setget , _get_values


##### PUBLIC METHODS #####
# mandatory method, process step on the step_sequencer
# by default, just assigns a value to the variable_path NodePath in the step_sequencer node
func step(step_sequencer: Node) -> void:
	step_sequencer.set_indexed(VARPATH, VALUES.value)


##### PROTECTED METHODS #####
# used to override the standard dictionary
func _get_values() -> Dictionary:
	if Engine.is_editor_hint():
		var values = VALUES
		if values == null:
			values = STANDARD_VALUES
		return values
	else:
		return VALUES
