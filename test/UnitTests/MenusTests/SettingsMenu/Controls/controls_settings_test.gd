# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the controls settings menu

##### VARIABLES #####
const FLOAT_APPROX := 0.1
const controls_path := "res://Game/Common/Menus/SettingsMenu/Controls/controls_settings.tscn"
var controls


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = controls_path
	.before()
	controls = load(controls_path).instance()
	controls._ready()


func after():
	.after()
	controls.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_tr() -> void:
	controls._init_tr()
	assert_str(controls.onready_paths.presets.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.PRESET_CATEGORY)
	)
	assert_str(controls.onready_paths.general.category.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CATEGORY)
	)
	assert_str(controls.onready_paths.movement_cat.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_CONTROLS_MOVEMENT_CATEGORY)
	)
	assert_str(controls.onready_paths.action_cat.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_CONTROLS_ACTION_CATEGORY)
	)
	assert_str(controls.onready_paths.ui_cat.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_CONTROLS_UI_CATEGORY)
	)

func test_set_default_values() -> void:
	controls._set_default_values()
	assert_float(controls.onready_paths.general.sensitivity.slider.value).is_equal_approx(SettingsUtils.settings_data.controls.mouse_sensitivity * 100.0,FLOAT_APPROX)
	assert_str(controls.onready_paths.general.sensitivity.line_edit.text).is_equal("%f" % (SettingsUtils.settings_data.controls.mouse_sensitivity * 100.0))

func test_connect_signals() -> void:
	controls._connect_signals()
	assert_bool(controls.onready_paths.general.sensitivity.slider.is_connected("value_changed",controls,"_on_SensitivitySlider_value_changed")).is_true()
	assert_bool(controls.onready_paths.general.sensitivity.line_edit.is_connected("text_changed", controls, "_on_SensitivityLineEdit_text_changed")).is_true()

func test_add_key_settings_to_groups() -> void:
	controls._add_key_settings_to_groups()
	assert_int(controls.onready_paths.movement.get_children().size()).is_equal(
		controls.MOVEMENT_CAT.size()
	)
	assert_int(controls.onready_paths.action.get_children().size()).is_equal(
		controls.ACTION_CAT.size()
	)
	assert_int(controls.onready_paths.ui.get_children().size()).is_equal(controls.UI_CAT.size())


func test_init_editable_key() -> void:
	var ret = controls._init_editable_key(GlobalTestUtilities.TEST_ACTION)
	assert_object(ret).is_instanceof(CommonEditableKey)
	assert_str(ret.ACTION_NAME).is_equal(GlobalTestUtilities.TEST_ACTION)
	ret.free()


func test_free_categories() -> void:
	# init
	controls.onready_paths.movement.add_child(Control.new())
	controls.onready_paths.action.add_child(Control.new())
	controls.onready_paths.ui.add_child(Control.new())
	# test
	controls._free_categories()
	assert_int(controls.onready_paths.movement.get_children().size()).is_equal(0)
	assert_int(controls.onready_paths.action.get_children().size()).is_equal(0)
	assert_int(controls.onready_paths.ui.get_children().size()).is_equal(0)

func test_on_SensitivitySlider_value_changed() -> void:
	var slider_val = 20.0
	controls._on_SensitivitySlider_value_changed(slider_val)
	assert_float(SettingsUtils.settings_data.controls.mouse_sensitivity).is_equal_approx(slider_val / 100.0,FLOAT_APPROX)
	assert_str(controls.onready_paths.general.sensitivity.line_edit.text).is_equal("%f" % slider_val)

func test_on_SensitivityLineEdit_text_changed() -> void:
	var test_1 := "5.0"
	controls._on_SensitivityLineEdit_text_changed(test_1)
	assert_float(SettingsUtils.settings_data.controls.mouse_sensitivity).is_equal_approx(test_1.to_float() / 100.0,FLOAT_APPROX)
	assert_float(controls.onready_paths.general.sensitivity.slider.value).is_equal_approx(test_1.to_float(), FLOAT_APPROX)
	var test_2 := "bidon"
	controls._on_SensitivityLineEdit_text_changed(test_2) # just checks that it does not crash
