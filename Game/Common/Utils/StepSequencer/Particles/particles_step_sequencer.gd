extends Particles
class_name ParticlesStepSequencer
# base class to send the trenchbroom specified parameters to the shader
# override _step in children classes
# Note : Don't be afraid to duplicate materials for each step, so that they will be treated simultaneously
"""
{
  "duplicate_material":"bool", # if each material should be duplicated to be computed independantly (a bit heavier in performances, but avoid creating potential duplicated materials)
  "signal_name": [ # Array of steps
	{ # Parameters to interact at step index, specified in children classes
		...
	}
  ],
  "signal_name_2": [
	{
	  ...
	}
  ]
}
"""

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _params = {}  # Parameters specified in Trenchbroom
var _step_indexes = {}  # To keep in track the indexes corresponding to different signals
var _material: Material


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()
	_init_step_indexes()


# Called when the node enters the scene tree for the first time.
func _ready():
	update_properties()
	_get_material_in_children_and_duplicate()

##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	if "params" in properties:
		self._params = properties["params"]


#==== Other things =====
func _init_step_indexes() -> void:
	for key in _params.keys():
		if key != "duplicate_material":
			_step_indexes[key] = 0


func _connect_signals() -> void:
	FunctionUtils.log_connect(
		SignalManager, self, "sequencer_step", "_on_SignalManager_sequencer_step"
	)


# Finds the first material in the first mesh instance and duplicates it if indicated in the params
func _get_material_in_children_and_duplicate() -> void:
	_material = process_material
	if _params.has("duplicate_material") and _params["duplicate_material"]:
		_material = _material.duplicate()  # duplicates the material, so that will truly be a "step"
		process_material = _material
	return


# function to execute at each step
# should be overriden by children classes
func _step(_parameters: Dictionary) -> void:
	pass


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_sequencer_step(id: String) -> void:
	if id in _step_indexes and id in _params and id != "duplicate_material" and _material != null:
		_step(_params[id][_step_indexes[id]])
		_step_indexes[id] = (_step_indexes[id] + 1) % _params[_step_indexes[id].size()]
