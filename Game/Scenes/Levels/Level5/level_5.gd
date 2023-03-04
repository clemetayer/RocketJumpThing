extends StandardScene
# Script for level 5

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const GROUP_REACTOR_CORE := "reactor_core"
const GROUP_BREAKABLE_LINK := "breakable_link"
const PART_1_ANIM_NAME := "part_1"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _env_switched := false

#==== ONREADY ====
onready var onready_paths := {"env_anim_tree": $WorldEnvironment/AnimationTree}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_init_func()


# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_func()


##### PROTECTED METHODS #####
# Called when the object is initialized.
func _init_func():
	._init_func()
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready_func():
	._ready_func()
	_init_onready_paths()
	_init_breakable_links()


func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.WALL_BROKEN, "_on_signal_manager_wall_broken"
	)


func _init_onready_paths() -> void:
	if onready_paths == null:
		onready_paths = {}
	onready_paths["reactor_core"] = get_tree().get_nodes_in_group(GROUP_REACTOR_CORE)
	onready_paths["breakable_links"] = get_tree().get_nodes_in_group(GROUP_BREAKABLE_LINK)


func _init_breakable_links() -> void:
	for breakable_link in onready_paths["breakable_links"]:
		breakable_link.target = breakable_link.get_path_to(onready_paths["reactor_core"][0])
		breakable_link.update_particles()


##### SIGNAL MANAGEMENT #####
func _on_signal_manager_wall_broken() -> void:
	if !_env_switched:
		var state_machine = onready_paths.env_anim_tree["parameters/playback"]
		if state_machine != null:
			state_machine.travel(PART_1_ANIM_NAME)
			_env_switched = true
	onready_paths["reactor_core"][0].next_anim()
