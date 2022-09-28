extends Spatial
class_name SpatialModifyMaterialParamStepSequencer
# base class to send the trenchbroom specified parameters to the shader
# override _step in children classes
# Note : Don't be afraid to duplicate materials for each step, so that they will be treated simultaneously
"""
{
  "duplicate_material":"bool", # if each material should be duplicated to be computed independantly (a bit heavier in performances, but avoid creating potential duplicated materials)
  "*":{}, # Parameters at start
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


# Called when the node enters the scene tree for the first time.
func _ready():
	update_properties()
	_init_step_indexes()
	_get_material_in_children_and_duplicate()
	_set_start_parameters()


##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass


##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	if "params_path" in properties:
		self._params = FunctionUtils.load_json(properties["params_path"])


#==== Other things =====
# sets the parameters at start (override this)
func _set_start_parameters() -> void:
	pass


func _init_step_indexes() -> void:
	for key in _params.keys():
		_step_indexes[key] = 0


func _connect_signals() -> void:
	FunctionUtils.log_connect(
		SignalManager, self, "sequencer_step", "_on_SignalManager_sequencer_step"
	)


# Finds the first material in the first mesh instance and duplicates it if indicated in the params
func _get_material_in_children_and_duplicate() -> void:
	for child in get_children():
		if child is MeshInstance:
			_material = child.mesh.surface_get_material(0)
			if _params.has("duplicate_material") and _params["duplicate_material"]:
				_material = _material.duplicate()  # duplicates the material, so that will truly be a "step"
				child.mesh.surface_set_material(0, _material)
			return


# function to execute at each step
# should be overriden by children classes
func _step(_parameters: Dictionary) -> void:
	pass


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_sequencer_step(id: String) -> void:
	if id in _step_indexes and id in _params and _material != null:
		_step(_params[id][_step_indexes[id]])
		_step_indexes[id] = (_step_indexes[id] + 1) % _params[id].size()
