extends StandardScene
# Scene 2 root script

##### VARIABLES #####
#---- CONSTANTS -----
const NEXT_SCENE_PATH := "res://Game/Scenes/Tutorial/Scene2/Scene2.tscn"


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.emit_trigger_tutorial("tutorial_scene_move_tutorial", 1.0)
	FunctionUtils.log_connect(SignalManager, self, "end_reached", "_on_SignalManager_end_reached")


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_end_reached() -> void:
	get_tree().change_scene(NEXT_SCENE_PATH)
