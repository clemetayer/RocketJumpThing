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
	get_node(_paths.next_scene_button).disabled = (next_scene_path == null or next_scene_path == "")
	_paths.next_scene = next_scene_path


##### PROTECTED METHODS #####
func _unpause():
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			_create_filter_auto_effect(),
			{StandardSongManager.get_current().name: {"fade_in": true}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	get_node(_paths.root_ui).hide()


func _create_filter_auto_effect() -> EffectManager:
	var effect = HalfFilterEffectManager.new()
	effect.TIME = 1.0
	return effect


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_end_reached() -> void:
	if VariableManager.end_level_enabled:
		PauseMenu.ENABLED = false
		if StandardSongManager.get_current() != null:
			StandardSongManager.apply_effect(
				_create_filter_auto_effect(),
				{StandardSongManager.get_current().name: {"fade_in": false}}
			)
		yield(get_tree().create_timer(0.1), "timeout")  # waits a little before pausing, to at least update the time in VariableManager. # OPTIMIZATION : this is pretty dirty, create a special signal to tell when the time was updated instead ?
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		VariableManager.pause_enabled = false
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
		tween.start()
		get_node(_paths.root_ui).show()
		get_tree().paused = true


func _on_NextButton_pressed():
	_unpause()
	get_tree().change_scene(_paths.next_scene)


func _on_RestartButton_pressed():
	_unpause()
	get_tree().reload_current_scene()


func _on_MainMenuButton_pressed():
	_unpause()
	get_tree().change_scene(_paths.main_menu_scene)
