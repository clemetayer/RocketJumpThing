# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the settings for the crosshair

##### VARIABLES #####
const FLOAT_APPROX := 0.1
const controls_settings_crosshair_path := "res://Game/Common/Menus/SettingsMenu/Controls/crosshair.tscn"
var controls_settings_crosshair


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = controls_settings_crosshair_path
	.before()
	controls_settings_crosshair = load(controls_settings_crosshair_path).instance()
	controls_settings_crosshair._ready()

func after():
	controls_settings_crosshair.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_tr() -> void:
	controls_settings_crosshair._init_tr()
	assert_str(controls_settings_crosshair.onready_paths.options.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CROSSHAIR_OPTION_TOOLTIP))
	assert_str(controls_settings_crosshair.onready_paths.color_picker.hint_tooltip).is_equal(tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CROSSHAIR_COLOR_TOOLTIP))

func test_connect_signals() -> void:
	controls_settings_crosshair._connect_signals()
	assert_bool(controls_settings_crosshair.onready_paths.options.is_connected("item_selected",controls_settings_crosshair,"_on_ToolButton_item_selected")).is_true()
	assert_bool(controls_settings_crosshair.onready_paths.size_edit.is_connected("text_changed",controls_settings_crosshair,"_on_SizeEdit_text_changed")).is_true()
	assert_bool(controls_settings_crosshair.onready_paths.color_picker.is_connected("color_changed",controls_settings_crosshair,"_on_Color_color_changed")).is_true()
	assert_bool(controls_settings_crosshair.onready_paths.size_slider.is_connected("value_changed",controls_settings_crosshair,"_on_SizeSlider_value_changed")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_SETTINGS, controls_settings_crosshair, "_on_SignalManager_update_settings")).is_true()

func test_init_crosshair_options() -> void:
	var test_crosshair_path_1 := "crosshair001.png"
	var test_crosshair_path_2 := "crosshair002.png"
	var test_crosshair_path_3 := "crosshair003.png"
	controls_settings_crosshair.onready_paths.options.clear()
	SettingsUtils.settings_data.controls.crosshair_path = "res://Misc/UI/Crosshairs/PNG/WhiteRetina/" + test_crosshair_path_2
	controls_settings_crosshair._init_crosshair_options(test_crosshair_path_1,0)
	controls_settings_crosshair._init_crosshair_options(test_crosshair_path_2,1)
	controls_settings_crosshair._init_crosshair_options(test_crosshair_path_3,2)
	assert_int(controls_settings_crosshair.onready_paths.options.get_item_count()).is_equal(3)
	assert_object(controls_settings_crosshair.onready_paths.options.get_item_icon(0)).is_not_null()
	assert_str(controls_settings_crosshair.onready_paths.options.get_item_text(0)).is_equal(test_crosshair_path_1.split(".")[0])
	assert_object(controls_settings_crosshair.onready_paths.options.get_item_icon(1)).is_not_null()
	assert_str(controls_settings_crosshair.onready_paths.options.get_item_text(1)).is_equal(test_crosshair_path_2.split(".")[0])
	assert_object(controls_settings_crosshair.onready_paths.options.get_item_icon(2)).is_not_null()
	assert_str(controls_settings_crosshair.onready_paths.options.get_item_text(2)).is_equal(test_crosshair_path_3.split(".")[0])
	assert_int(controls_settings_crosshair.onready_paths.options.selected).is_equal(1)

func test_init_current_crosshair() -> void:
	var test_path := "res://Misc/UI/Crosshairs/PNG/WhiteRetina/crosshair009.png"
	var test_size := 1.5
	var test_color := Color.aliceblue
	SettingsUtils.settings_data.controls.crosshair_path = test_path
	SettingsUtils.settings_data.controls.crosshair_size = test_size
	SettingsUtils.settings_data.controls.crosshair_color = test_color
	controls_settings_crosshair._init_current_crosshair()
	assert_object(controls_settings_crosshair.onready_paths.preview.texture).is_not_null()
	assert_float(controls_settings_crosshair.onready_paths.size_slider.value).is_equal_approx(test_size,FLOAT_APPROX)
	assert_str(controls_settings_crosshair.onready_paths.size_edit.text).is_equal("%f" % test_size)
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_min_size).is_equal(controls_settings_crosshair.STANDARD_SIZE * test_size)
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_scale).is_equal(Vector2.ONE * test_size)
	assert_object(controls_settings_crosshair.onready_paths.color_picker.color).is_equal(test_color)
	assert_object(controls_settings_crosshair.onready_paths.preview.modulate).is_equal(test_color)
	
func test_on_ToolButton_item_selected() -> void:
	var test_crosshair_path_1 := "crosshair001.png"
	var test_crosshair_path_2 := "crosshair002.png"
	var test_crosshair_path_3 := "crosshair003.png"
	controls_settings_crosshair.onready_paths.options.clear()
	controls_settings_crosshair._init_crosshair_options(test_crosshair_path_1,0)
	controls_settings_crosshair._init_crosshair_options(test_crosshair_path_2,1)
	controls_settings_crosshair._init_crosshair_options(test_crosshair_path_3,2)
	controls_settings_crosshair._on_ToolButton_item_selected(1)
	assert_object(controls_settings_crosshair.onready_paths.preview.texture).is_not_null()
	assert_str(SettingsUtils.settings_data.controls.crosshair_path).is_equal(controls_settings_crosshair.CROSSHAIR_FOLDER + test_crosshair_path_2)

func test_on_SizeEdit_text_changed() -> void:
	var test_float = "2.5"
	var test_non_float = "test"
	controls_settings_crosshair._on_SizeEdit_text_changed(test_float)
	assert_float(controls_settings_crosshair.onready_paths.size_slider.value).is_equal_approx(test_float.to_float(), FLOAT_APPROX)
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_min_size).is_equal(controls_settings_crosshair.STANDARD_SIZE * test_float.to_float())
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_scale).is_equal(Vector2.ONE * test_float.to_float())
	assert_float(SettingsUtils.settings_data.controls.crosshair_size).is_equal_approx(test_float.to_float(), FLOAT_APPROX)
	# tests if it stays the same on an invalid string
	controls_settings_crosshair._on_SizeEdit_text_changed(test_non_float)
	assert_float(controls_settings_crosshair.onready_paths.size_slider.value).is_equal_approx(test_float.to_float(), FLOAT_APPROX)
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_min_size).is_equal(controls_settings_crosshair.STANDARD_SIZE * test_float.to_float())
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_scale).is_equal(Vector2.ONE * test_float.to_float())
	assert_float(SettingsUtils.settings_data.controls.crosshair_size).is_equal_approx(test_float.to_float(), FLOAT_APPROX)


func test_on_Color_color_changed() -> void:
	var test_color := Color.antiquewhite
	controls_settings_crosshair._on_Color_color_changed(test_color)
	assert_object(controls_settings_crosshair.onready_paths.preview.modulate).is_equal(test_color)
	assert_object(SettingsUtils.settings_data.controls.crosshair_color).is_equal(test_color)

func test_on_SizeSlider_value_changed() -> void:
	var test_float = 1.5
	controls_settings_crosshair._on_SizeSlider_value_changed(test_float)
	assert_str(controls_settings_crosshair.onready_paths.size_edit.text).is_equal("%f" % test_float)
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_min_size).is_equal(controls_settings_crosshair.STANDARD_SIZE * test_float)
	assert_vector2(controls_settings_crosshair.onready_paths.preview.rect_scale).is_equal(Vector2.ONE * test_float)
	assert_float(SettingsUtils.settings_data.controls.crosshair_size).is_equal_approx(test_float, FLOAT_APPROX)
	