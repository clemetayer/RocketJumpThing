extends Node
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
export var MATERIALS_TO_UPDATE = [] setget _set_materials  # shader materials to update

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if SignalManager.connect("speed_updated", self, "_on_SignalManager_speed_updated") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"speed_updated",
					"_on_SignalManager_speed_updated",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass


##### PROTECTED METHODS #####
func _set_materials(new_materials: Array) -> void:
	for i in range(new_materials.size()):
		if new_materials[i] == null:
			new_materials[i] = {"material": SpatialMaterial.new(), "param_name": ""}
	MATERIALS_TO_UPDATE = new_materials


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_speed_updated(speed: float) -> void:
	for material in MATERIALS_TO_UPDATE:
		material.material.set_shader_param(material.param_name, speed)
