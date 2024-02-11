# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the default settings

##### VARIABLES #####
const FLOAT_APPROX := 0.5  # float approximation for dBs
const default_settings_path := "Game/Common/Menus/DefaultSettings/default_settings.tscn"
var default_settings


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = default_settings_path
	.before()
	default_settings = load(default_settings_path).instance()
	default_settings._ready()

func after():
	default_settings.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_play_intro_anim() -> void:
	default_settings.play_intro_anim()
	assert_bool(default_settings.onready_paths.animation_player.is_playing()).is_true()
	assert_str(default_settings.onready_paths.animation_player.current_animation).is_equal(default_settings.INTRO_ANIM_NAME)

func test_init_tr() -> void:
	default_settings._init_tr()
	assert_str(default_settings.onready_paths.language.category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_CATEGORY))
	assert_str(default_settings.onready_paths.video.category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_VIDEO_DISPLAY_CATEGORY))
	assert_str(default_settings.onready_paths.audio.category.CATEGORY_NAME).is_equal(tr(TranslationKeys.MENU_SETTINGS_TAB_AUDIO))
	assert_str(default_settings.onready_paths.controls.category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CATEGORY))
	assert_str(default_settings.onready_paths.gameplay.category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_GAMEPLAY_CATEGORY))
	assert_str(default_settings.onready_paths.gameplay.label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.options.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.options.get_item_text(0)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL))
	assert_str(default_settings.onready_paths.gameplay.options.get_item_tooltip(0)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.options.get_item_text(1)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME))
	assert_str(default_settings.onready_paths.gameplay.options.get_item_tooltip(1)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.options.get_item_text(2)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE))
	assert_str(default_settings.onready_paths.gameplay.options.get_item_tooltip(2)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.space_to_wallride_label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_SPACE_TO_WALL_RIDE_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.space_to_wallride_check.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_SPACE_TO_WALL_RIDE_TOOLTIP))
	assert_str(default_settings.onready_paths.gameplay.air_maneuverability_label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_AIR_STRAFE_MANEUVERABILITY_TOOLTIP))

func test_init_options() -> void:
	default_settings.onready_paths.language.options.clear()
	default_settings.onready_paths.video.options.clear()
	default_settings._init_options()
	assert_int(default_settings.onready_paths.language.options.get_item_count()).is_equal(TranslationServer.get_loaded_locales().size())
	assert_int(default_settings.onready_paths.video.options.get_item_count()).is_equal(2)

func test_connect_signals() -> void:
	assert_bool(default_settings.onready_paths.language.options.is_connected("item_selected",default_settings,"_on_LanguageOptions_item_selected")).is_true()
	assert_bool(default_settings.onready_paths.video.options.is_connected("item_selected",default_settings,"_on_VideoOptions_item_selected")).is_true()
	assert_bool(default_settings.onready_paths.audio.slider.is_connected("value_changed",default_settings,"_on_AudioSlider_value_changed")).is_true()
	assert_bool(default_settings.onready_paths.audio.mute.is_connected("toggled",default_settings,"_on_AudioMute_toggled")).is_true()
	assert_bool(default_settings.onready_paths.controls.options.is_connected("item_selected",default_settings,"_on_ControlsOptions_item_selected")).is_true()
	assert_bool(default_settings.onready_paths.gameplay.options.is_connected("item_selected",default_settings,"_on_GameplayOptions_item_selected")).is_true()
	assert_bool(default_settings.onready_paths.confirm.is_connected("pressed",default_settings,"_on_Ok_pressed")).is_true()
	assert_bool(default_settings.onready_paths.gameplay.space_to_wallride_check.is_connected("toggled",default_settings,"_on_SpaceToWallrideCheck_toggled")).is_true()
	assert_bool(default_settings.onready_paths.gameplay.air_maneuverability_slider.is_connected("value_changed", default_settings,"_on_AirManeuverabilitySlider_value_changed")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.TRANSLATION_UPDATED,default_settings,"_on_SignalManager_translation_updated")).is_true()

func test_apply_keyboard_layout() -> void:
	default_settings._apply_keyboard_layout("dvorak.cfg")
	assert_str(SettingsUtils.settings_presets.controls).is_equal("dvorak.cfg")
	assert_signal(SignalManager).is_emitted(SignalManager.UPDATE_KEYS)

func test_on_VideoOptions_item_selected() -> void:
	# full screen
	default_settings._on_VideoOptions_item_selected(default_settings.window_modes.FULL_SCREEN)
	assert_bool(OS.window_fullscreen).is_true()
	# windowed
	default_settings._on_VideoOptions_item_selected(default_settings.window_modes.WINDOWED)
	assert_bool(OS.window_fullscreen).is_false()

func test_on_AudioSlider_value_changed() -> void:
	var VOLUME := 51.2 # %
	default_settings._on_AudioSlider_value_changed(VOLUME)
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))).is_equal_approx(
		linear2db(VOLUME / default_settings.onready_paths.audio.slider.max_value), FLOAT_APPROX
	)
	assert_str(default_settings.onready_paths.audio.volume_label.text).is_equal(default_settings.VOLUME_TEXT % VOLUME)

func test_on_AudioMute_toggled() -> void:
	var UNMUTE := false
	default_settings._on_AudioMute_toggled(UNMUTE)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))).is_equal(
		not UNMUTE
	)
	assert_bool(default_settings.onready_paths.audio.slider.editable).is_equal(UNMUTE)

func test_on_GameplayOptions_item_selected() -> void:
	default_settings._on_GameplayOptions_item_selected(2)
	assert_int(SettingsUtils.settings_data.gameplay.tutorial_level).is_equal(2)

func test_on_SpaceToWallrideCheck_toggled() -> void:
	default_settings._on_SpaceToWallrideCheck_toggled(true)
	assert_bool(SettingsUtils.settings_data.gameplay.space_to_wall_ride).is_true()
	default_settings._on_SpaceToWallrideCheck_toggled(false)
	assert_bool(SettingsUtils.settings_data.gameplay.space_to_wall_ride).is_false()

func test_on_AirManeuverabilitySlider_value_changed() -> void:
	default_settings._on_AirManeuverabilitySlider_value_changed(5.1)
	assert_float(SettingsUtils.settings_data.gameplay.air_strafe_maneuverability).is_equal_approx(5.1, FLOAT_APPROX)