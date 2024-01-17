extends Control
# Settings menu

##### SIGNALS #####
signal return_to_prev_menu

##### VARIABLES #####
#---- CONSTANTS -----
const TAB_NAME_VARIABLE := "TAB_NAME"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"return": $"Margin/VBoxContainer/Return", "tabs": $"Margin/VBoxContainer/Settings"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_tr()


##### PRIVATE METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.return, self, "pressed", "_on_Return_pressed")
	DebugUtils.log_connect(SignalManager,self,SignalManager.TRANSLATION_UPDATED,"_on_SignalManager_translation_updated")


func _init_tr() -> void:
	_init_tab_names()
	onready_paths.return.text = tr(TranslationKeys.MENU_RETURN)


func _init_tab_names() -> void:
	for tab_idx in range(onready_paths.tabs.get_children().size()):
		if onready_paths.tabs.get_child(tab_idx).get(TAB_NAME_VARIABLE) != null:
			onready_paths.tabs.set_tab_title(
				tab_idx, tr(onready_paths.tabs.get_child(tab_idx).get(TAB_NAME_VARIABLE))
			)


##### SIGNAL MANAGEMENT #####
func _on_Return_pressed() -> void:
	SettingsUtils.save_current_settings()
	emit_signal("return_to_prev_menu")
	SignalManager.emit_update_settings()

func _on_SignalManager_translation_updated() -> void:
	_init_tr()
