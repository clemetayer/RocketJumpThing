extends WorldEnvironment
# common world environment parameters

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_performance_parameters()

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, SignalManager.UPDATE_SETTINGS, "_on_SignalManager_update_settings")

func _init_performance_parameters() -> void:
	environment.ss_reflections_enabled = SettingsUtils.settings_data.graphics.reflections
	environment.glow_enabled = SettingsUtils.settings_data.graphics.glow

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_update_settings() -> void:
	_init_performance_parameters()
