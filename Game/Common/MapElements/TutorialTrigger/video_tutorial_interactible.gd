extends Collidable
# VideoTutorialInteractible

##### VARIABLES #####
#---- CONSTANTS -----
const TB_TUTORIAL_INTERACTIBLE := [["video_path", "_video_path"]]  # mapper for TrenchBroom parameters

#---- STANDARD -----
#==== PRIVATE ====
var _video_path: String

#==== ONREADY ====
onready var onready_path := {
	"collision_shape":$"CollisionShape"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_activate_tutorial()
	_connect_signals()

##### PROTECTED METHODS #####
func _ready_activate_tutorial() -> void:
	_toggle_active(SettingsUtils.settings_data.gameplay.tutorial_level != SettingsUtils.TUTORIAL_LEVEL.none)

func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_TUTORIAL_INTERACTIBLE)

func _toggle_active(enabled : bool) -> void:
	visible = enabled
	onready_path.collision_shape.disabled = not enabled

func _connect_signals() -> void:
	DebugUtils.log_connect(self,self,"body_entered", "_on_area_tutorial_trigger_body_entered")

##### SIGNAL MANAGEMENT #####
func _on_area_tutorial_trigger_body_entered(body):
	if FunctionUtils.is_player(body):
		MenuNavigator.show_video_tutorial(_video_path)

func _on_SignalManager_update_settings() -> void:
	_ready_activate_tutorial()
