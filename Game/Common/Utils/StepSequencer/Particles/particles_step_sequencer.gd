extends Particles
# A step sequencer for spatial nodes
# Note : Don't be afraid to duplicate materials for each step, so that they will be treated simultaneously
# Note to (maybe) angry future self : Making a base class might be a bad idea, since it would lose the static/spatial extends
"""
{
  "duplicate_material":"bool", # if each material should be duplicated to be computed independantly (a bit heavier in performances, but avoid creating potential duplicated materials)
  "*":[{},...], # Parameters at start
  "signal_name": [ # Array of steps
	{ # Parameters to interact at step index, specified in children classes
		"0": # parameters for simple set param (see sequencer_types)
		{
			...
		},
		"1":
		{
			...
		},
		etc.
	},
	etc.
  ],
  "signal_name_2": [
	{
		"0": # parameters for simple set param (see sequencer_types)
		{
			...
		},
		"1":
		{
			...
		},
		etc.
	},
	etc.
  ]
}
"""

##### ENUMS #####
enum sequencer_types { SET_PARAM, TWEEN, PULSE, EMIT }

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
var material: Material  # material of the body

#==== PRIVATE ====
var _params_path: String
var _params = {}  # Parameters specified in Trenchbroom
var _step_indexes = {}  # To keep in track the indexes corresponding to different signals
var _active_on_steps: String
var _active_on_signals: String
var _active_on_steps_array = []  # array of indexes where the effect should be active
var _active_on_signals_array = []  # array of signals where the effect should be active
var _init_index: int  # index of the start parameter values to initialize


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	StepSequencerCommon.connect_signals(self)


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	_active_on_steps_array = StepSequencerCommon.parse_active_on_steps(_active_on_steps)
	_active_on_signals_array = StepSequencerCommon.parse_active_on_signals(_active_on_signals)
	_params = FunctionUtils.load_json(_params_path)
	_step_indexes = StepSequencerCommon.init_step_indexes(_params)
	_get_material_in_children_and_duplicate()
	StepSequencerCommon.set_start_parameters(self, _params, _init_index)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, StepSequencerCommon.TB_STEP_SEQUENCER_PARAM_MAPPER
	)


# Finds the first material in the first mesh instance and duplicates it if indicated in the params
func _get_material_in_children_and_duplicate() -> void:
	for child in get_children():
		if child is MeshInstance:
			material = child.mesh.surface_get_material(0)
			if _params.has("duplicate_material") and _params["duplicate_material"]:
				material = material.duplicate()  # duplicates the material, so that will truly be a "step"
				child.mesh.surface_set_material(0, material)
			return


# function to execute at each step
# should be overriden by children classes
func _step(parameters: Dictionary) -> void:
	StepSequencerCommon.common_step(self, parameters)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_sequencer_step(id: String) -> void:
	_step_indexes = StepSequencerCommon.process_sequencer_step(
		self,
		id,
		_params,
		_step_indexes,
		_active_on_signals_array,
		material != null,
		_active_on_steps_array
	)
