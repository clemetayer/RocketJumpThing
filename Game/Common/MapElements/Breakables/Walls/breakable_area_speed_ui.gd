extends Viewport
# Used to show the speed on breakable wall

##### VARIABLES #####
#---- CONSTANTS -----
const COLOR_NOK := Color(1, 0, 0, 1)  # color of the text if the player speed is < to the treshold
const COLOR_OK := Color(0, 1, 0, 1)  # color of the text if the player speed is >= to the treshold

#---- EXPORTS -----
export(float) var SPEED = 0  # Speed to show on the Sprite3D
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"label": $"Label"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_label()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager,
		self,
		SignalManager.SPEED_UPDATED,
		"_on_breakable_area_speed_ui_speed_updated"
	)


func _init_label() -> void:
	if onready_paths.label != null:
		onready_paths.label.text = str(SPEED)
		size = onready_paths.label.rect_size


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_ui_speed_updated(speed: float):
	if onready_paths.label != null:
		onready_paths.label.set(
			"custom_colors/font_color", COLOR_OK if speed >= SPEED else COLOR_NOK
		)
