extends CanvasLayer
# Script for the pause menu

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5

#---- EXPORTS -----
export(bool) var ENABLED

#---- STANDARD -----
#==== PRIVATE ====
var _paths := {
	"tween": "./OpacityTween",
	"root_ui": "./UI",
	"main_menu_scene": "res://Game/Common/Menus/MainMenu/main_menu.tscn",
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(_paths.root_ui).hide()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if get_node(_paths.root_ui).visible:
			_unpause()
		elif ENABLED:
			_pause()


##### PROTECTED METHODS #####
func _pause():
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			_create_filter_auto_effect(),
			{StandardSongManager.get_current().name: {"fade_in": false}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	get_node(_paths.root_ui).show()


func _unpause():
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			_create_filter_auto_effect(),
			{StandardSongManager.get_current().name: {"fade_in": true}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	get_node(_paths.root_ui).hide()


func _create_filter_auto_effect() -> EffectManager:  # REFACTOR : make a global method (it is used somewhere else, and might be used again)
	var effect = HalfFilterEffectManager.new()
	effect.TIME = FADE_IN_TIME
	return effect


##### SIGNAL MANAGEMENT #####
func _on_ResumeButton_pressed():
	_unpause()


func _on_MainMenuButton_pressed():
	_unpause()
	get_tree().change_scene(_paths.main_menu_scene)


func _on_OptionButton_pressed():
	# TODO
	pass  # Replace with function body.


func _on_RestartButton_pressed():
	_unpause()
	get_tree().reload_current_scene()
