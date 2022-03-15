extends CanvasLayer
# End level UI class

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5

#---- STANDARD -----
#==== PRIVATE ====
var _paths := {
	"label": "./UI/CenterContainer/VBoxContainer/Time",
	"tween": "./OpacityTween",
	"root_ui": "./UI",
	"main_menu_scene": "res://Game/Common/Menus/MainMenu/main_menu.tscn",
	"next_scene": null,
	"next_scene_button": "./UI/CenterContainer/VBoxContainer/Buttons/NextButton"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(_paths.root_ui).hide()
	FunctionUtils.log_connect(SignalManager, self, "end_reached", "_on_SignalManager_end_reached")


##### PUBLIC METHODS #####
func set_next_scene(next_scene_path: String) -> void:
	_paths.next_scene = next_scene_path


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_end_reached() -> void:
	if _paths.next_scene == null:
		get_node(_paths.next_scene_button).disabled = true
	var tween: Tween = get_node(_paths.tween)
	var millis = VariableManager.chronometer.level % 1000
	var seconds = floor((VariableManager.chronometer.level / 1000) % 60)
	var minutes = floor(VariableManager.chronometer.level / (1000 * 60))
	get_node(_paths.label).set_text("%02d : %02d : %03d" % [minutes, seconds, millis])
	tween.interpolate_property(
		get_node(_paths.root_ui), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), FADE_IN_TIME
	)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	tween.start()
	get_node(_paths.root_ui).show()


func _unpause():
	get_tree().paused = false


func _on_NextButton_pressed():
	get_tree().change_scene(_paths.next_scene)


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()


func _on_MainMenuButton_pressed():
	get_tree().change_scene(_paths.main_menu_scene)
