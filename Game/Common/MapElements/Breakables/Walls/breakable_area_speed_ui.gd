extends Viewport
# Used to show the speed on breakable wall

##### VARIABLES #####
#---- CONSTANTS -----
const COLOR_NOK := Color(1, 0, 0, 1)  # color of the text if the player speed is < to the treshold
const COLOR_OK := Color(0, 1, 0, 1)  # color of the text if the player speed is >= to the treshold

#---- EXPORTS -----
export(float) var SPEED = 0  # Speed to show on the Sprite3D


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_label()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	if (
		SignalManager.connect("speed_updated", self, "_on_breakable_area_speed_ui_speed_updated")
		!= OK
	):
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"speed_updated",
					"_on_breakable_area_speed_ui_speed_updated",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


func _init_label() -> void:
	$Label.text = str(SPEED)
	size = $Label.rect_size


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_ui_speed_updated(speed: float):
	$Label.set("custom_colors/font_color", COLOR_OK if speed >= SPEED else COLOR_NOK)
