# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the gameplay settings menu

##### VARIABLES #####
const FLOAT_APPROX := 0.1
const gameplay_path := "res://Game/Common/Menus/SettingsMenu/Gameplay/gameplay_settings.tscn"
var gameplay


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = gameplay_path
	.before()
	gameplay = load(gameplay_path).instance()
	gameplay._ready()


func after():
	.after()
	gameplay.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_tr() -> void:
	gameplay._init_tr()
	assert_str(gameplay.onready_paths.gameplay_category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_GAMEPLAY_CATEGORY))
	assert_str(gameplay.onready_paths.tutorial_category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_CATEGORY))
	assert_str(gameplay.onready_paths.difficulty_category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_DIFFICULTY))
	assert_str(gameplay.onready_paths.movement.category.CATEGORY_NAME).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_AIR_STRAFE_MANEUVERABILITY_LABEL))
	assert_str(gameplay.onready_paths.fov.label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_FOV_TOOLTIP))
	assert_str(gameplay.onready_paths.fov.slider.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_FOV_TOOLTIP))
	assert_str(gameplay.onready_paths.fov.edit.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_FOV_TOOLTIP))
	assert_str(gameplay.onready_paths.space_to_wallride_check.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_SPACE_TO_WALL_RIDE_TOOLTIP))
	assert_str(gameplay.onready_paths.space_to_wallride_check_label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_SPACE_TO_WALL_RIDE_TOOLTIP))
	assert_str(gameplay.onready_paths.tutorial.level_label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP))
	assert_str(gameplay.onready_paths.tutorial.level.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_TOOLTIP))
	assert_str(gameplay.onready_paths.tutorial.level.get_item_text(0)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL))
	assert_str(gameplay.onready_paths.tutorial.level.get_item_tooltip(0)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_ALL_TOOLTIP))
	assert_str(gameplay.onready_paths.tutorial.level.get_item_text(1)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME))
	assert_str(gameplay.onready_paths.tutorial.level.get_item_tooltip(1)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_SOME_TOOLTIP))
	assert_str(gameplay.onready_paths.tutorial.level.get_item_text(2)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE))
	assert_str(gameplay.onready_paths.tutorial.level.get_item_tooltip(2)).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_TUTORIAL_LEVEL_NONE_TOOLTIP))
	assert_str(gameplay.onready_paths.difficulty.additionnal_jumps.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_ADDITIONAL_JUMPS_TOOLTIP))
	assert_str(gameplay.onready_paths.difficulty.additionnal_jumps_label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_ADDITIONAL_JUMPS_TOOLTIP))
	assert_str(gameplay.onready_paths.movement.air_maneuverability_label.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_GAMEPLAY_AIR_STRAFE_MANEUVERABILITY_TOOLTIP))

func test_set_default_values() -> void:
	SettingsUtils.settings_data.gameplay.fov = 78.95
	SettingsUtils.settings_data.gameplay.space_to_wall_ride = true
	SettingsUtils.settings_data.gameplay.tutorial_level = 1
	gameplay._set_default_values()
	assert_str(gameplay.onready_paths.fov.edit.text).is_equal("%f" % SettingsUtils.settings_data.gameplay.fov)
	assert_float(gameplay.onready_paths.fov.slider.value).is_equal_approx(SettingsUtils.settings_data.gameplay.fov, FLOAT_APPROX)
	assert_bool(gameplay.onready_paths.space_to_wallride_check.pressed).is_true()
	assert_int(gameplay.onready_paths.tutorial.level.selected).is_equal(1)
	assert_float(gameplay.onready_paths.movement.air_maneuverability_slider.value).is_equal_approx(SettingsUtils.settings_data.gameplay.air_strafe_maneuverability, FLOAT_APPROX)

func test_connect_signals() -> void:
	gameplay._connect_signals()
	assert_bool(gameplay.onready_paths.fov.slider.is_connected("value_changed",gameplay,"_on_FovSlider_value_changed")).is_true()
	assert_bool(gameplay.onready_paths.fov.edit.is_connected("text_changed",gameplay,"_on_FovEdit_text_changed")).is_true()
	assert_bool(gameplay.onready_paths.space_to_wallride_check.is_connected("toggled",gameplay,"_on_SpaceToWallrideCheck_toggled")).is_true()
	assert_bool(gameplay.onready_paths.tutorial.level.is_connected("item_selected",gameplay,"_on_TutorialLevel_item_selected")).is_true()
	assert_bool(gameplay.onready_paths.difficulty.additionnal_jumps.is_connected("value_changed",gameplay,"_on_AdditionnalJumps_value_changed")).is_true()
	assert_bool(gameplay.onready_paths.movement.air_maneuverability_slider.is_connected("value_changed",gameplay,"_on_AirManeuverabilitySlider_value_changed")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_SETTINGS, gameplay, "_on_SignalManager_update_settings")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.TRANSLATION_UPDATED, gameplay,"_on_SignalManager_translation_updated")).is_true()

func test_on_FovSlider_value_changed() -> void:
	var test_fov = 54.86
	gameplay._on_FovSlider_value_changed(test_fov)
	assert_str(gameplay.onready_paths.fov.edit.text).is_equal("%f" % test_fov)
	assert_float(SettingsUtils.settings_data.gameplay.fov).is_equal_approx(test_fov,FLOAT_APPROX)


func test_on_FovEdit_text_changed() -> void:
	var test_fov = "86.44"
	gameplay._on_FovEdit_text_changed(test_fov)
	assert_float(gameplay.onready_paths.fov.slider.value).is_equal_approx(86.44,FLOAT_APPROX)
	assert_float(SettingsUtils.settings_data.gameplay.fov).is_equal_approx(86.44,FLOAT_APPROX)

func test_on_SpaceToWallrideCheck_toggled() -> void:
	gameplay._on_SpaceToWallrideCheck_toggled(true)
	assert_bool(SettingsUtils.settings_data.gameplay.space_to_wall_ride).is_true()
	gameplay._on_SpaceToWallrideCheck_toggled(false)
	assert_bool(SettingsUtils.settings_data.gameplay.space_to_wall_ride).is_false()

func test_on_TutorialLevel_item_selected() -> void:
	gameplay._on_TutorialLevel_item_selected(2)
	assert_int(SettingsUtils.settings_data.gameplay.tutorial_level).is_equal(2)

func test_on_AdditionnalJumps_value_changed() -> void:
	gameplay._on_AdditionnalJumps_value_changed(5)
	assert_int(SettingsUtils.settings_data.gameplay.additionnal_jumps).is_equal(5)

func test_on_AirManeuverabilitySlider_value_changed() -> void:
	gameplay._on_AirManeuverabilitySlider_value_changed(2.5)
	assert_float(SettingsUtils.settings_data.gameplay.air_strafe_maneuverability).is_equal_approx(2.5, FLOAT_APPROX)