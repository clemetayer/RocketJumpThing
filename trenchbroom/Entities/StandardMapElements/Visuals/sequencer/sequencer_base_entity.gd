extends Node
class_name SequencerBaseEntity
# A static body that makes something visually cool on a specific sequence

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
export (Dictionary) var properties setget set_properties

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _step := 0  # Current step 
var _id: String  # Identifier of the sequencer 
var _number_of_steps: int  # Number of steps in total for the elements with the same ID
var _number: int  # Number of the element alone

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if SignalManager.connect("sequencer_step", self, "_on_SignalManager_sequencer_step") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"sequencer_step",
					"_on_SignalManager_sequencer_step",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


# Called when the node enters the scene tree for the first time.
func _ready():
	if 'id' in properties:
		self._id = properties.id
	if 'number_of_steps' in properties:
		self._number_of_steps = properties.number_of_steps
	if 'number' in properties:
		self._number = properties.number


##### PUBLIC METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties


##### PROTECTED METHODS #####
# function to do when this is the correct step 
# Override this
func _step_function() -> void:
	pass


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_sequencer_step(id: String) -> void:
	if id == _id and _step == _number:
		_step_function()
	_step = (_step + 1) % _number_of_steps
