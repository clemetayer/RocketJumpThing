extends Node
class_name StandardScene
# A standard template for scenes

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS ----
export (Dictionary) var PATHS = {"player": NodePath(), "start_point": NodePath()}  # various path for the scene

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _last_cp: Checkpoint

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_autoload_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_last_cp = get_node(PATHS.start_point).get_checkpoint()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass


##### PUBLIC METHODS #####
# checks if the scene is valid, intended to be used as a guard before entering the scene
# actually might be a bit complex to implement
func check_scene_validity() -> bool:
	# TODO : Check node paths, etc. But maybe a bit complex to implement
	return true


##### PROTECTED METHODS #####
# Connects the autoload signals on init
func _connect_autoload_signals() -> void:
	if SignalManager.connect("checkpoint_triggered", self, "_on_checkpoint_triggered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% ["body_exited", "_on_body_exited", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if (
		SignalManager.connect("respawn_player_on_last_cp", self, "_on_respawn_player_on_last_cp")
		!= OK
	):
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% ["body_exited", "_on_body_exited", DebugUtils.print_stack_trace(get_stack())]
			)
		)


##### SIGNAL MANAGEMENT #####
func _on_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	_last_cp = checkpoint


func _on_respawn_player_on_last_cp() -> void:
	var player: Player = get_node(PATHS.player)
	player.transform.origin = _last_cp.get_spawn_point()
	player.vel = Vector3()
