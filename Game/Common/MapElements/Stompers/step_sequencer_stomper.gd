extends Stomper
# A thing that stomps mixed with a step sequencer

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _sequencer_data_path := ""  # json file of the step sequencer parameter
var _sequencer_data: SequencerData
var _active_on_steps := ""  # array (as a string) of steps where the sequencer is active
var _active_on_steps_array := []  # array of steps where the sequencer is active
var _active_on_signals := ""  # array (as a string) of signals where the sequencer is active
var _active_on_signals_array := []  # array of signals where the sequencer is active
var _init_index: int  # index of the start parameter values to initialize


##### PROTECTED METHODS #####
# overriden from parent
func _ready_func() -> void:
	._ready_func()
	_active_on_steps_array = StepSequencerCommon.parse_active_on_steps(_active_on_steps)
	_active_on_signals_array = StepSequencerCommon.parse_active_on_signals(_active_on_signals)
	_sequencer_data = ResourceLoader.load(_sequencer_data_path)
	StepSequencerCommon.set_start_parameters(self, _sequencer_data, _init_index)


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
	StepSequencerCommon.process_sequencer_step(
		self, id, _sequencer_data, _active_on_signals_array, _active_on_steps_array
	)
