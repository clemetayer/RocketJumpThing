extends CanvasLayer
# Script for the player user interface

##### VARIABLES #####
#==== PUBLIC ====
var speed := 0.0 setget set_speed

#==== ONREADY ====
onready var onready_paths := {
	"speed_text": $"Screen/SpeedCenter/SpeedContainer/SpeedText",
	"crosshair": $"Screen/CrosshairCenter/CrosshairControl/Crosshair",
	"crosshair_size_control" :$"Screen/CrosshairCenter/CrosshairControl",
	"update_ui_init": $"UpdateUIOnInit"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_set_crosshair( 
		SettingsUtils.settings_data.controls.crosshair_path, 
		SettingsUtils.settings_data.controls.crosshair_color, 
		SettingsUtils.settings_data.controls.crosshair_size
	) # Kind of useless here, just to "hide" the default crosshair at the start. But the correct crosshair won't have a correct size...
	onready_paths.update_ui_init.start()

##### PUBLIC METHODS #####
func set_speed(pspeed: float):
	speed = stepify(pspeed, 0.01)
	_set_speed_text()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager,self,SignalManager.UPDATE_CROSSHAIR,"_on_SignalManager_update_crosshair")
	DebugUtils.log_connect(onready_paths.update_ui_init, self, "timeout", "_on_UpdateUIOnInit_timeout")

func _set_crosshair(path : String, color : Color, scale : float) -> void:
	Logger.debug("path : %s, color : %s, scale : %s" % [path,color,scale])
	onready_paths.crosshair.texture = FunctionUtils.get_texture_at_path(path, Vector2.ONE * GlobalConstants.CROSSHAIR_STANDARD_SIZE)
	onready_paths.crosshair.modulate = color
	onready_paths.crosshair_size_control.rect_scale = Vector2.ONE * scale


func _set_speed_text() -> void:
	if onready_paths.speed_text != null:
		onready_paths.speed_text.bbcode_text = TextUtils.BBCode_center_text("%.2f" % speed)

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_update_crosshair(path : String, color : Color, scale : float) -> void:
	_set_crosshair(path, color, scale)

# Kind of a hack to avoid an accidental reset of the crosshair by waiting a bit after _ready
func _on_UpdateUIOnInit_timeout() -> void:
	_set_crosshair(
		SettingsUtils.settings_data.controls.crosshair_path, 
		SettingsUtils.settings_data.controls.crosshair_color, 
		SettingsUtils.settings_data.controls.crosshair_size
	)
