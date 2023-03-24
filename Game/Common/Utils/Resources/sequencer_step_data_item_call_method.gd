tool
extends SequencerStepDataItem
class_name SequencerStepDataItemCallMethod
# A step sequencer that simply calls a method on the step sequencer
# TODO : add some securities (check beforehand if the method exists in the step sequencer, if VALUES has key, etc.)

##### VARIABLES #####
#---- CONSTANTS -----
const CALL_METHOD_VALUES := {"args": []}  # parameters of the varpath (which is the method name)


##### PUBLIC METHODS #####
# mandatory method, process step on the step_sequencer
# calls the method
func step(step_sequencer: Node) -> void:
	step_sequencer.callv(VARPATH, CALL_METHOD_VALUES.args)


##### PROTECTED METHODS #####
# used to override the standard dictionary
func _get_values() -> Dictionary:
	if Engine.is_editor_hint():
		var values = VALUES
		if values == null:
			values = CALL_METHOD_VALUES
		return values
	else:
		return VALUES
