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
const ANIMATION_PARTS := ["part_0","part_1","part_2","part_3","part_4","part_5"]
const NUMBER_OF_WALLS := 5 # the amount of walls to break at the start
const TIME_TO_WAIT_FOR_ACCESS_GRANTED_MESSAGE := 2 # time in seconds to show the "access tho the anomaly granted message"
const COLOR_PALETTE_GRADIENT_STEPS := ["#0000ff","#4b00b4","#870078","#be0041","#ff0000"]
const TEXT_COLOR_ACCESS_TO_ENTITY_GRANTED := "#ffffff"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _env_switched := false
var _animation_idx := 0
var _walls_remaining := NUMBER_OF_WALLS

#==== ONREADY ====
onready var onready_paths := {"env_anim_tree": $DirectionalLight/AnimationTree}


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
	if not SignalManager.is_connected(SignalManager.WALL_BROKEN, self, "_on_signal_manager_wall_broken"):
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
	# alters the environment
	var state_machine = onready_paths.env_anim_tree["parameters/playback"]
	if state_machine != null and _animation_idx <= ANIMATION_PARTS.size():
		_animation_idx += 1
		state_machine.travel(ANIMATION_PARTS[_animation_idx])
	onready_paths["reactor_core"][0].next_anim()
	# shows a special message
	_walls_remaining -= 1
	if _walls_remaining <= 0:
		SignalManager.emit_ui_message(
			TextUtils.BBCode_color_text(
				TextUtils.BBCode_center_text(
					tr(TranslationKeys.PLAYER_MESSAGE_SECURITY_DISABLED)
				)
			, TEXT_COLOR_ACCESS_TO_ENTITY_GRANTED)
		)
		yield(get_tree().create_timer(TIME_TO_WAIT_FOR_ACCESS_GRANTED_MESSAGE),"timeout")
		SignalManager.emit_ui_message(
			TextUtils.BBCode_color_text(
				TextUtils.BBCode_center_text(
					tr(TranslationKeys.PLAYER_MESSAGE_ACCESS_TO_ANOMALY_GRANTED)
				)
			, TEXT_COLOR_ACCESS_TO_ENTITY_GRANTED)
		)
	else:
		SignalManager.emit_ui_message(
				TextUtils.BBCode_center_text(
					tr(TranslationKeys.PLAYER_MESSAGE_SECURITY_STATUS) 
					+ TextUtils.BBCode_color_text("%s%%" % (_walls_remaining*100.0/NUMBER_OF_WALLS)
						, COLOR_PALETTE_GRADIENT_STEPS[clamp(NUMBER_OF_WALLS - _walls_remaining,0,NUMBER_OF_WALLS)])
				) 

		)

func _on_Kick_timeout() -> void:
	SignalManager.emit_sequencer_step("kick")
