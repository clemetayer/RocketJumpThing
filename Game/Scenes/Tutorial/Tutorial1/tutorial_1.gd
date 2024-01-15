extends StandardScene
# Scene 2 root script


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	if SettingsUtils.settings_data.gameplay.tutorial_level == SettingsUtils.TUTORIAL_LEVEL.all:
		SignalManager.emit_trigger_tutorial("tutorial_scene_move_tutorial", 1.0)
