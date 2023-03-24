tool
extends Resource
class_name SequencerSteps
# A step for the sequencer

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- EXPORTS -----
export(String) var SIGNAL_KEY  # key of the sequencer step signal
export(Array) var SEQUENCER_STEPS = [] setget , _get_sequencer_steps  # Sequencer steps as step data

#==== PRIVATE ====
var _current_idx := 0  # current sequencer step idx


##### PUBLIC METHODS #####
# increments the step idx
func next_step(id: String) -> void:
	if id == SIGNAL_KEY:
		_current_idx = (_current_idx + 1) % SEQUENCER_STEPS.size()


# Calls the correct step sequencer step method, if the current idx is in the array of valid step sequencer's id, then increases the step count
# for instance, if the _current_idx = 1 and step_sequencer_valid_idx = [0,2], this will do nothing
func call_step(step_sequencer: Node, step_sequencer_valid_idx: Array, step_id: String) -> void:
	if (
		step_id == SIGNAL_KEY
		and _current_idx in step_sequencer_valid_idx
		and SEQUENCER_STEPS[_current_idx] is SequencerStepData
	):
		SEQUENCER_STEPS[_current_idx].call_steps_process(step_sequencer)


##### PROTECTED METHODS #####
# To bypass godot's limitation for custom resources export hints
func _get_sequencer_steps() -> Array:
	if Engine.is_editor_hint():
		var sequencer_steps = SEQUENCER_STEPS
		for sequencer_steps_idx in range(sequencer_steps.size()):
			if sequencer_steps[sequencer_steps_idx] == null:
				sequencer_steps[sequencer_steps_idx] = SequencerStepData.new()
				SEQUENCER_STEPS = sequencer_steps
		return sequencer_steps
	else:
		return SEQUENCER_STEPS
