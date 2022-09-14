extends StandardScene
# Scene 2 root script


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.emit_trigger_tutorial("tutorial_scene_move_tutorial", 1.0)
