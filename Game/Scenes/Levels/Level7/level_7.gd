# tool
extends StandardScene
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

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
var _entity: Spatial

#==== ONREADY ====
onready var onready_paths := {
	"entity_animation_player": $"AdditionalThings/EntityStuff/EntityAnimation"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager,
		self,
		SignalManager.TRIGGER_ENTITY_ANIMATION,
		"_on_SignalManager_TriggerEntityAnimation"
	)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_TriggerEntityAnimation(animation):
	if onready_paths.entity_animation_player != null:
		onready_paths.entity_animation_player.play(animation)
