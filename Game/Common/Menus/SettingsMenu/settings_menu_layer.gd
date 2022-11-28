extends CanvasLayer
# A canvas layer to display the settings menu conveniently

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"settings_menu": $"SettingsMenu"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.settings_menu, self, "return_signal", "_on_SettingsMenu_return"
	)


##### SIGNAL MANAGEMENT #####
func _on_SettingsMenu_return() -> void:
	queue_free()
