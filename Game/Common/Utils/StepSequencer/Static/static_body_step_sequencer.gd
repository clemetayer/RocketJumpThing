extends Collidable
# A step sequencer for static bodies
# Note to (maybe) angry future self : Making a base class might be a bad idea, since it would lose the static/spatial extends

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
var material: Material  # material of the body

#==== PRIVATE ====
var _sequencer_data_path: String
var _sequencer_data: SequencerData  # Parameters specified in Trenchbroom
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
	_sequencer_data = ResourceLoader.load(_sequencer_data_path)
	_get_material_in_children_and_duplicate()
	StepSequencerCommon.set_start_parameters(self, _sequencer_data, _init_index)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, StepSequencerCommon.TB_STEP_SEQUENCER_PARAM_MAPPER
	)


# Finds the first material in the first mesh instance and duplicates it if indicated in the params
func _get_material_in_children_and_duplicate() -> void:
	for child in get_children():
		if child is MeshInstance:
			material = child.mesh.surface_get_material(0)
			if _sequencer_data.DUPLICATE_MATERIAL:
				material = material.duplicate()  # duplicates the material, so that will truly be a "step"
				child.mesh.surface_set_material(0, material)
			return


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_sequencer_step(id: String) -> void:
	StepSequencerCommon.process_sequencer_step(
		self, id, _sequencer_data, _active_on_signals_array, _active_on_steps_array
	)
