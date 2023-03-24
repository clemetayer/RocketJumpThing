extends Reference
class_name StepSequencerCommon
# A common class for the step sequencers, used as an utility tool to avoid code duplication

##### VARIABLES #####
#---- CONSTANTS -----
const START_PARAMETERS_KEY := "*"  # the key in the json dictionary to indicate the start parameters
const SPLIT_ACTIVE_SEPARATOR := ","  # separator used to split the active on steps/signals strings
const TB_STEP_SEQUENCER_PARAM_MAPPER := [
	["sequencer_data_path", "_sequencer_data_path"],
	["active_on_steps", "_active_on_steps"],
	["active_on_signals", "_active_on_signals"],
	["init_index", "_init_index"]
]  # mapper for TrenchBroom parameters


##### PUBLIC METHODS #####
static func connect_signals(step_sequencer: Node) -> void:
	DebugUtils.log_connect(
		SignalManager,
		step_sequencer,
		SignalManager.SEQUENCER_STEP,
		"_on_SignalManager_sequencer_step"
	)


static func parse_active_on_steps(active_on_steps: String) -> Array:
	var active_on_steps_array := []
	if active_on_steps != null:
		for el in active_on_steps.split(SPLIT_ACTIVE_SEPARATOR):
			if el.is_valid_integer():
				active_on_steps_array.append(int(el))
	return active_on_steps_array


static func parse_active_on_signals(active_on_signals: String) -> Array:
	var active_on_signals_array := []
	if active_on_signals != null:
		active_on_signals_array = active_on_signals.split(SPLIT_ACTIVE_SEPARATOR)
	return active_on_signals_array


# maybe a bit too many parameters, that's a bit hard to read
static func process_sequencer_step(
	step_sequencer: Node,
	id: String,
	sequencer_data: SequencerData,
	active_on_signals_array: Array,
	active_on_steps_array: Array
) -> void:
	if id in active_on_signals_array:
		sequencer_data.call_steps(step_sequencer, id, active_on_steps_array)


static func set_start_parameters(
	step_sequencer: Node, sequencer_data: SequencerData, init_index: int
) -> void:
	sequencer_data.init_data(step_sequencer, init_index)
