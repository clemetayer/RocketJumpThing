extends Collidable
# A simple area that triggers a signal when the player enters the area

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal trigger()

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

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
	_connect_signals()

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_COLLIDABLE_MAPPER)

func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_area_trigger_body_entered")

##### SIGNAL MANAGEMENT #####
func _on_area_trigger_body_entered(body) -> void:
	if FunctionUtils.is_player(body):
		emit_signal("trigger")
