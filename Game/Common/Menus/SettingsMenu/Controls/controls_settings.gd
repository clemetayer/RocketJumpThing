extends VBoxContainer
# Remaps the controls

##### VARIABLES #####
#---- CONSTANTS -----
const TAB_NAME := "Controls"
const EDITABLE_KEY_PATH := "res://Game/Common/Menus/SettingsMenu/Controls/common_editable_key.tscn"
const MOVEMENT_CAT := [  # actions for the movement category
	VariableManager.INPUT_MVT_FORWARD,
	VariableManager.INPUT_MVT_BACKWARD,
	VariableManager.INPUT_MVT_LEFT,
	VariableManager.INPUT_MVT_RIGHT,
	VariableManager.INPUT_MVT_JUMP,
	VariableManager.INPUT_MVT_SLIDE,
]
const ACTION_CAT := [  # actions for the action category
	VariableManager.INPUT_ACTION_SHOOT,
	VariableManager.INPUT_RESTART_LAST_CP,
	VariableManager.INPUT_RESTART
]
const UI_CAT := [  # actions for the UI category
	VariableManager.INPUT_PAUSE,
]

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"movement": $"KeysMargin/KeysScroll/Keys/Movement/MovementGrid",
	"action": $"KeysMargin/KeysScroll/Keys/Action/ActionGrid",
	"ui": $"KeysMargin/KeysScroll/Keys/UI/UIGrid"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_add_key_settings_to_groups()


##### PROTECTED METHODS #####
func _add_key_settings_to_groups() -> void:
	_free_categories()
	for mvt_action in MOVEMENT_CAT:
		onready_paths.movement.add_child(_init_editable_key(mvt_action))
	for action_action in ACTION_CAT:
		onready_paths.action.add_child(_init_editable_key(action_action))
	for ui_action in UI_CAT:
		onready_paths.ui.add_child(_init_editable_key(ui_action))


# inits an editable key from an action in parameters
func _init_editable_key(action: String) -> CommonEditableKey:
	var editable_key = load(EDITABLE_KEY_PATH).instance()
	editable_key.ACTION_NAME = action
	return editable_key


# removes the childrens in each input category
func _free_categories() -> void:
	for child in onready_paths.movement.get_children():
		child.free()
	for child in onready_paths.action.get_children():
		child.free()
	for child in onready_paths.ui.get_children():
		child.free()
