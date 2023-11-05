extends MarginContainer
# Gameplay settings

##### VARIABLES #####
#---- CONSTANTS -----
const TAB_NAME := "MENU_SETTINGS_TAB_GAMEPLAY"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"gameplay_category":$"VBoxContainer/Gameplay",
	"tutorial_category":$"VBoxContainer/Tutorials",
	"fov": {
		"label":$"VBoxContainer/Gameplay/FOV/Label",
		"slider":$"VBoxContainer/Gameplay/FOV/HSlider",
		"edit":$"VBoxContainer/Gameplay/FOV/LineEdit"
	},
	"space_to_wallride_check":$"VBoxContainer/Gameplay/SpaceToWallRide/CheckButton",
	"space_to_wallride_check_label":$"VBoxContainer/Gameplay/SpaceToWallRide/Label",
	"tutorial": {
		"level_label":$"VBoxContainer/Tutorials/TutorialLevel/Label",
		"level":$"VBoxContainer/Tutorials/TutorialLevel/OptionButton"
	}
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_set_default_values()
	_connect_signals()

##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.gameplay_category.set_category_name(tr(TranslationKeys.SETTINGS_GAMEPLAY_GAMEPLAY_CATEGORY))
	onready_paths.tutorial_category.set_category_name(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_CATEGORY))
	onready_paths.fov.label.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_FOV_TOOLTIP)
	onready_paths.fov.slider.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_FOV_TOOLTIP)
	onready_paths.fov.edit.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_FOV_TOOLTIP)
	onready_paths.space_to_wallride_check.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_SPACE_TO_WALL_RIDE_TOOLTIP)
	onready_paths.space_to_wallride_check_label.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_SPACE_TO_WALL_RIDE_TOOLTIP)
	onready_paths.tutorial.level_label.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP)
	onready_paths.tutorial.level.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP)
	onready_paths.tutorial.level.set_item_text(0,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL))
	onready_paths.tutorial.level.set_item_tooltip(0,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL_TOOLTIP))
	onready_paths.tutorial.level.set_item_text(1,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME))
	onready_paths.tutorial.level.set_item_tooltip(1,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME_TOOLTIP))
	onready_paths.tutorial.level.set_item_text(2,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE))
	onready_paths.tutorial.level.set_item_tooltip(2,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE_TOOLTIP))

func _set_default_values():
	onready_paths.fov.edit.text = "%f" % SettingsUtils.settings_data.gameplay.fov
	onready_paths.fov.slider.value = SettingsUtils.settings_data.gameplay.fov
	onready_paths.space_to_wallride_check.pressed = SettingsUtils.settings_data.gameplay.space_to_wall_ride
	onready_paths.tutorial.level.select(SettingsUtils.settings_data.gameplay.tutorial_level)


func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.fov.slider, self, "value_changed", "_on_FovSlider_value_changed")
	DebugUtils.log_connect(onready_paths.fov.edit, self, "text_changed", "_on_FovEdit_text_changed")
	DebugUtils.log_connect(onready_paths.space_to_wallride_check, self, "toggled", "_on_SpaceToWallrideCheck_toggled")
	DebugUtils.log_connect(onready_paths.tutorial.level, self, "item_selected", "_on_TutorialLevel_item_selected")

##### SIGNAL MANAGEMENT #####
func _on_FovSlider_value_changed(value : float) -> void:
	if(onready_paths.fov.edit.text != "%f" % value):
		onready_paths.fov.edit.set_text("%f" % value )
	SettingsUtils.set_fov(value)

func _on_FovEdit_text_changed(new_text : String) -> void:
	if(new_text.is_valid_float()):
		SettingsUtils.set_fov(new_text.to_float())
		if(onready_paths.fov.slider.value != new_text.to_float()):
			onready_paths.fov.slider.value = new_text.to_float()

func _on_SpaceToWallrideCheck_toggled(pressed : bool) -> void:
	SettingsUtils.set_space_to_wall_ride(pressed)

func _on_TutorialLevel_item_selected(index : int) -> void:
	SettingsUtils.settings_data.gameplay.tutorial_level = index
