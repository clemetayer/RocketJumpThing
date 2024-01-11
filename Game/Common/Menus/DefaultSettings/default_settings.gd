extends Control
# Script to control the simple settings menu

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum window_modes { WINDOWED, FULL_SCREEN }

##### VARIABLES #####
#---- CONSTANTS -----
const INTRO_ANIM_NAME := "show_message"
const VOLUME_TEXT := "%d%%"  # label displaying the volume
const KEYBOARD_CONFIG_NAMES = ["qwerty.cfg","qwertz.cfg","azerty.cfg","dvorak.cfg","colemak.cfg","workman.cfg"]

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
onready var onready_paths := {
	"language":{
		"category":$"CenterContainer/VBoxContainer/Language",
		"options":$"CenterContainer/VBoxContainer/Language/HBoxContainer/LanguageOptions"
	},
	"video":{
		"category":$"CenterContainer/VBoxContainer/Video",
		"options":$"CenterContainer/VBoxContainer/Video/HBoxContainer/Options"
	},
	"audio":{
		"category":$"CenterContainer/VBoxContainer/Audio",
		"slider":$CenterContainer/VBoxContainer/Audio/HBoxContainer/Slider,
		"volume_label":$"CenterContainer/VBoxContainer/Audio/HBoxContainer/Volume",
		"mute":$"CenterContainer/VBoxContainer/Audio/HBoxContainer/Mute"
	},
	"controls":{
		"category":$"CenterContainer/VBoxContainer/Controls",
		"options":$"CenterContainer/VBoxContainer/Controls/HBoxContainer/OptionButton"
	},
	"gameplay":{
		"category":$"CenterContainer/VBoxContainer/Gameplay",
		"label":$"CenterContainer/VBoxContainer/Gameplay/TutorialLevel/Label",
		"options":$"CenterContainer/VBoxContainer/Gameplay/TutorialLevel/OptionButton"
	},
	"animation_player":$"AnimationPlayer",
	"confirm":$"CenterContainer/VBoxContainer/Ok"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_init_options()
	_connect_signals()

##### PUBLIC METHODS #####
# plays the intro animation of the menu
func play_intro_anim() -> void:
	onready_paths.animation_player.play(INTRO_ANIM_NAME)

##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.language.category.set_category_name(tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_CATEGORY))
	onready_paths.video.category.set_category_name(tr(TranslationKeys.SETTINGS_VIDEO_DISPLAY_CATEGORY))
	onready_paths.audio.category.set_category_name(tr(TranslationKeys.SETTINGS_AUDIO_MAIN_CATEGORY))
	onready_paths.controls.category.set_category_name(tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CATEGORY))
	onready_paths.gameplay.category.set_category_name(tr(TranslationKeys.SETTINGS_GAMEPLAY_GAMEPLAY_CATEGORY))
	onready_paths.gameplay.label.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP)
	onready_paths.gameplay.options.hint_tooltip = tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP)
	onready_paths.gameplay.options.set_item_text(0,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL))
	onready_paths.gameplay.options.set_item_tooltip(0,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL_TOOLTIP))
	onready_paths.gameplay.options.set_item_text(1,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME))
	onready_paths.gameplay.options.set_item_tooltip(1,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME_TOOLTIP))
	onready_paths.gameplay.options.set_item_text(2,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE))
	onready_paths.gameplay.options.set_item_tooltip(2,tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE_TOOLTIP))

func _init_options() -> void:
	_init_language_options()
	_init_video_options()
	onready_paths.audio.volume_label.text = VOLUME_TEXT % onready_paths.audio.slider.value

func _init_language_options() -> void:
	var locales := TranslationServer.get_loaded_locales()
	for locale_idx in range(locales.size()):
		onready_paths.language.options.add_item(
			TranslationServer.get_locale_name(locales[locale_idx]), locale_idx
		)

func _init_video_options() -> void:
	onready_paths.video.options.add_item(
		tr(TranslationKeys.SETTINGS_VIDEO_WINDOWED), window_modes.WINDOWED
	)
	onready_paths.video.options.add_item(
		tr(TranslationKeys.SETTINGS_VIDEO_FULL_SCREEN), window_modes.FULL_SCREEN
	)

func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.language.options,self,"item_selected","_on_LanguageOptions_item_selected")
	DebugUtils.log_connect(onready_paths.video.options,self,"item_selected","_on_VideoOptions_item_selected")
	DebugUtils.log_connect(onready_paths.audio.slider,self,"value_changed","_on_AudioSlider_value_changed")
	DebugUtils.log_connect(onready_paths.audio.mute,self,"toggled","_on_AudioMute_toggled")
	DebugUtils.log_connect(onready_paths.controls.options,self,"item_selected","_on_ControlsOptions_item_selected")
	DebugUtils.log_connect(onready_paths.gameplay.options,self,"item_selected","_on_GameplayOptions_item_selected")
	DebugUtils.log_connect(onready_paths.confirm,self,"pressed","_on_Ok_pressed")

func _apply_keyboard_layout(cfg_name : String) -> void:
	SettingsUtils.load_inputs_cfg(DebugUtils.log_load_cfg(SettingsUtils.INPUT_PRESETS_PATH + cfg_name))
	SettingsUtils.settings_presets.controls = cfg_name
	SignalManager.emit_update_keys()

##### SIGNAL MANAGEMENT #####
func _on_LanguageOptions_item_selected(idx:int) -> void:
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[idx])

func _on_VideoOptions_item_selected(idx:int) -> void:
	match idx:
		window_modes.FULL_SCREEN:
			OS.set_window_fullscreen(true)
		window_modes.WINDOWED:
			OS.set_window_fullscreen(false)

func _on_AudioSlider_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS),
		linear2db(value / onready_paths.audio.slider.max_value)
	)
	onready_paths.audio.volume_label.text = VOLUME_TEXT % value

func _on_AudioMute_toggled(toggled : bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), not toggled)
	onready_paths.audio.slider.editable = toggled

func _on_ControlsOptions_item_selected(idx:int) -> void:
	_apply_keyboard_layout(KEYBOARD_CONFIG_NAMES[idx])

func _on_GameplayOptions_item_selected(idx:int) -> void:
	SettingsUtils.settings_data.gameplay.tutorial_level = idx

func _on_Ok_pressed() -> void:
	SignalManager.emit_update_settings()
	MenuNavigator.exit_navigation()
	MenuNavigator.show_main_menu()
