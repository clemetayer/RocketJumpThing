tool
extends Resource
class_name SequencerData
# Data for sequencers
# Note : the step index management is done by this resource and the SequencerSteps,
# to only update it ONCE when receiving the step sequencer signal

##### VARIABLES #####
#---- EXPORTS -----
export(bool) var DUPLICATE_MATERIAL = true  # If the sequencer is using a trenchbroom mesh as a child, indicates to duplicate this material to avoid modifying other materias. For other resources, it is better to use the "local to scene" flag
export(Array) var INIT_PARAMS setget , _get_init_param
export(Array) var STEPS = [] setget , _get_steps


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.SEQUENCER_STEP, "_on_SignalManager_sequencer_step"
	)


##### PUBLIC METHODS #####
func init_data(step_sequencer: Node, init_index: int) -> void:
	if (
		init_index < INIT_PARAMS.size()
		and INIT_PARAMS[init_index] != null
		and INIT_PARAMS[init_index] is SequencerInitParam
	):
		INIT_PARAMS[init_index].init_step_sequencer(step_sequencer)


func call_steps(step_sequencer: Node, step_id: String, step_sequencer_valid_steps: Array) -> void:
	for step in STEPS:
		step.call_step(step_sequencer, step_sequencer_valid_steps, step_id)


##### PROTECTED METHODS #####
# To bypass godot's limitation for custom resources export hints
func _get_init_param() -> Array:
	if Engine.is_editor_hint():
		var init_param = INIT_PARAMS
		for init_param_idx in range(init_param.size()):
			if init_param[init_param_idx] == null:
				init_param[init_param_idx] = SequencerInitParam.new()
				INIT_PARAMS = init_param
		return init_param
	else:
		return INIT_PARAMS


func _get_steps() -> Array:
	if Engine.is_editor_hint():
		var steps = STEPS
		for step_idx in range(steps.size()):
			if steps[step_idx] == null:
				steps[step_idx] = SequencerSteps.new()
				STEPS = steps
		return steps
	else:
		return STEPS


##### SIGNAL MANAGEMENT #####
# increments the step counter of the id
func _on_SignalManager_sequencer_step(id: String) -> void:
	for step in STEPS:
		if step is SequencerSteps and step.SIGNAL_KEY == id:
			step.next_step(id)
