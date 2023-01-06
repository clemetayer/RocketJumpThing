extends Stomper
# A thing that stomps mixed with a step sequencer

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _params_path := ""  # json file of the step sequencer parameter
var _params := {}  # actual parameters loaded
var _active_on_steps := ""  # array (as a string) of steps where the sequencer is active
var _active_on_steps_array := []  # array of steps where the sequencer is active
var _active_on_signals := ""  # array (as a string) of signals where the sequencer is active
var _active_on_signals_array := []  # array of signals where the sequencer is active
var _init_index := 0  # start index
var _step_indexes := {}


##### PROTECTED METHODS #####
# mandatory for the step sequencer, parameters are unused here
func _step(_step_params: Dictionary) -> void:
	._stomp()


# overriden from parent
func _ready_func() -> void:
	._ready_func()
	_params = FunctionUtils.load_json(_params_path)
	_active_on_steps_array = StepSequencerCommon.parse_active_on_steps(_active_on_steps)
	_active_on_signals_array = StepSequencerCommon.parse_active_on_signals(_active_on_signals)
	_step_indexes = StepSequencerCommon.init_step_indexes(_params)


# overriden from parent
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, StepSequencerCommon.TB_STEP_SEQUENCER_PARAM_MAPPER
	)


# overriden from parent
func _connect_signals() -> void:
	._connect_signals()
	StepSequencerCommon.connect_signals(self)


##### SIGNAL MANAGEMENT #####
# mandatory for the step sequencer
func _on_SignalManager_sequencer_step(id: String) -> void:
	_step_indexes = StepSequencerCommon.process_sequencer_step(
		self, id, _params, _step_indexes, _active_on_signals_array, _active_on_steps_array
	)
