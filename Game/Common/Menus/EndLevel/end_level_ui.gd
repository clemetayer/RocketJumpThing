extends CanvasLayer
# End level UI class

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"label": $"UI/CenterContainer/VBoxContainer/Time",
	"tween": $"OpacityTween",
	"root_ui": $"UI",
	"next_scene_button": $"UI/CenterContainer/VBoxContainer/Buttons/NextButton"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.root_ui.hide()
	_connect_signals()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, "end_reached", "_on_SignalManager_end_reached")


func _unpause():
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			_create_filter_auto_effect(),
			{StandardSongManager.get_current().name: {"fade_in": true}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	onready_paths.root_ui.hide()


func _create_filter_auto_effect() -> EffectManager:
	var effect = HalfFilterEffectManager.new()
	effect.TIME = FADE_IN_TIME
	return effect


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_end_reached() -> void:
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			_create_filter_auto_effect(),
			{StandardSongManager.get_current().name: {"fade_in": false}}
		)
	yield(get_tree().create_timer(0.1), "timeout")  # waits a little before pausing, to at least update the time in VariableManager. # OPTIMIZATION : this is pretty dirty, create a special signal to tell when the time was updated instead ?
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	onready_paths.next_scene_button.disabled = not ScenesManager.has_next_level()
	var tween: Tween = onready_paths.tween
	var millis = fmod(VariableManager.chronometer.level, 1000)
	var seconds = floor(fmod(VariableManager.chronometer.level / 1000, 60))
	var minutes = floor(VariableManager.chronometer.level / (1000 * 60))
	onready_paths.label.set_text("%02d : %02d : %03d" % [minutes, seconds, millis])
	DebugUtils.log_tween_interpolate_property(
		tween, onready_paths.root_ui, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), FADE_IN_TIME
	)
	DebugUtils.log_tween_start(tween)
	onready_paths.root_ui.show()
	get_tree().paused = true


func _on_NextButton_pressed():
	_unpause()
	ScenesManager.next_level()


func _on_RestartButton_pressed():
	_unpause()
	ScenesManager.reload_current()


func _on_MainMenuButton_pressed():
	_unpause()
	ScenesManager.load_main_menu()
