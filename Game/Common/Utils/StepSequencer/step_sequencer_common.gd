extends Reference
class_name StepSequencerCommon
# A common class for the step sequencers, used as an utility tool to avoid code duplication
# Not the best, but better than nothing I guess

##### ENUMS #####
enum sequencer_types { SET_PARAM, TWEEN, PULSE, EMIT }

##### VARIABLES #####
#---- CONSTANTS -----
const START_PARAMETERS_KEY := "*"  # the key in the json dictionary to indicate the start parameters
const SPLIT_ACTIVE_SEPARATOR := ","  # separator used to split the active on steps/signals strings
const TB_STEP_SEQUENCER_PARAM_MAPPER := [
	["params_path", "_params_path"],
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


static func init_step_indexes(params: Dictionary) -> Dictionary:
	var step_indexes := {}
	for key in params.keys():
		step_indexes[key] = 0
	return step_indexes


static func _is_step_id_valid(id: String, step_indexes: Dictionary, params: Dictionary) -> bool:
	return id in step_indexes and id in params


static func _is_step_and_signal_active(
	id: String, step: int, active_on_signals_array: Array, active_on_steps_array: Array
) -> bool:
	return id in active_on_signals_array and step in active_on_steps_array


# maybe a bit too many parameters, that's a bit hard to read
static func process_sequencer_step(
	step_sequencer: Node,
	id: String,
	params: Dictionary,
	step_indexes: Dictionary,
	active_on_signals_array: Array,
	active_on_steps_array: Array
) -> Dictionary:
	if _is_step_id_valid(id, step_indexes, params):
		if (
			_is_step_and_signal_active(
				id, step_indexes[id], active_on_signals_array, active_on_steps_array
			)
			and step_sequencer.has_method("_step")
		):
			step_sequencer._step(params[id][step_indexes[id]])
		step_indexes[id] = (step_indexes[id] + 1) % params[id].size()
	return step_indexes


static func set_start_parameters(step_sequencer: Node, params: Dictionary, init_index: int) -> void:
	if params.has(START_PARAMETERS_KEY):
		if init_index < params[START_PARAMETERS_KEY].size():
			for key in params[START_PARAMETERS_KEY][init_index].keys():
				step_sequencer.set_indexed(key, params[START_PARAMETERS_KEY][init_index][key])


static func common_step(step_sequencer: Node, params: Dictionary) -> void:
	for param_type in params.keys():
		if param_type.is_valid_integer():
			var stepper
			match int(param_type):
				sequencer_types.SET_PARAM:
					stepper = StepperSetParam.new()
				sequencer_types.TWEEN:
					stepper = StepperTween.new()
				sequencer_types.PULSE:
					stepper = StepperPulse.new()
			step_sequencer.add_child(stepper)
			stepper.step(step_sequencer, params[param_type])
