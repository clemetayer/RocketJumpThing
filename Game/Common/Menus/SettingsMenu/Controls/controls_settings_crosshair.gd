extends VBoxContainer
# Crosshair selection

##### VARIABLES #####
#---- CONSTANTS -----
const STANDARD_SIZE := Vector2.ONE * GlobalConstants.CROSSHAIR_STANDARD_SIZE # Normal size of the preview (for a scale of 1)
const CROSSHAIR_FOLDER := "res://Misc/UI/Crosshairs/PNG/WhiteRetina/"

#---- STANDARD -----
#==== PRIVATE ====
var _crosshair_paths := {}

#==== ONREADY ====
onready var onready_paths := {
	"options":$"CrosshairOptions/ToolButton",
	"size_slider":$"CrosshairOptions/Size/SizeSlider",
	"size_label":$"CrosshairOptions/Size/Label",
	"size_edit":$"CrosshairOptions/Size/LineEdit",
	"color_picker":$"CrosshairOptions/HBoxContainer/Color",
	"preview":$"CenterContainer/Preview"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_connect_signals()
	var crosshair_file_names = FunctionUtils.list_dir_files(CROSSHAIR_FOLDER,SettingsUtils.REGEX_PATTERN_PNG_FILE)
	crosshair_file_names.sort()
	var options_idx := 0
	for file_name in crosshair_file_names:
		_init_crosshair_options(file_name, options_idx)
		options_idx += 1
	_init_current_crosshair()

##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.options.hint_tooltip = tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CROSSHAIR_OPTION_TOOLTIP)
	onready_paths.color_picker.hint_tooltip = tr(TranslationKeys.SETTINGS_CONTROLS_GENERAL_CROSSHAIR_COLOR_TOOLTIP)

func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.options,self,"item_selected","_on_ToolButton_item_selected")
	DebugUtils.log_connect(onready_paths.size_edit,self,"text_changed", "_on_SizeEdit_text_changed")
	DebugUtils.log_connect(onready_paths.color_picker,self,"color_changed", "_on_Color_color_changed")
	DebugUtils.log_connect(onready_paths.size_slider, self, "value_changed", "_on_SizeSlider_value_changed")
	DebugUtils.log_connect(SignalManager, self, SignalManager.UPDATE_SETTINGS, "_on_SignalManager_update_settings")
	DebugUtils.log_connect(SignalManager,self,SignalManager.TRANSLATION_UPDATED,"_on_SignalManager_translation_updated")

func _init_crosshair_options(crosshair_file_name : String, options_idx : int) -> void:
	var crosshair_name = crosshair_file_name.split(".")[0]
	var icon = FunctionUtils.get_texture_at_path(CROSSHAIR_FOLDER + crosshair_file_name, Vector2(20,20))
	_crosshair_paths[crosshair_name] = CROSSHAIR_FOLDER + crosshair_file_name
	onready_paths.options.add_icon_item(icon,crosshair_name, options_idx)
	if(SettingsUtils.settings_data.controls.crosshair_path == CROSSHAIR_FOLDER + crosshair_file_name):
		onready_paths.options.select(options_idx)

func _init_current_crosshair() -> void:
	# inits the crosshair preview
	var crosshair_path = SettingsUtils.settings_data.controls.crosshair_path
	onready_paths.preview.texture = load(crosshair_path)
	# inits the size slider and value
	var crosshair_size = SettingsUtils.settings_data.controls.crosshair_size
	onready_paths.size_slider.value = crosshair_size
	onready_paths.size_edit.text = "%f" % crosshair_size
	onready_paths.preview.rect_min_size = STANDARD_SIZE * crosshair_size
	onready_paths.preview.rect_scale = Vector2.ONE * crosshair_size
	# inits the color
	var crosshair_color = SettingsUtils.settings_data.controls.crosshair_color
	onready_paths.color_picker.color = crosshair_color
	onready_paths.preview.modulate = crosshair_color


##### SIGNAL MANAGEMENT #####
func _on_ToolButton_item_selected(idx : int) -> void:
	var crosshair_name = onready_paths.options.get_item_text(idx)
	var image_path = _crosshair_paths[crosshair_name]
	var image = FunctionUtils.get_texture_at_path(image_path, STANDARD_SIZE)
	onready_paths.preview.texture = image
	SettingsUtils.set_crosshair_path(_crosshair_paths[crosshair_name])

func _on_SizeEdit_text_changed(new_text : String) -> void:
	if new_text.is_valid_float():
		onready_paths.preview.rect_min_size = STANDARD_SIZE * new_text.to_float()
		onready_paths.preview.rect_scale = Vector2.ONE * new_text.to_float()
		if(onready_paths.size_slider.value != new_text.to_float()):
			onready_paths.size_slider.value = new_text.to_float()
		SettingsUtils.set_crosshair_size(new_text.to_float())


func _on_Color_color_changed(color : Color) -> void:
	onready_paths.preview.modulate = color
	SettingsUtils.set_crosshair_color(color)

func _on_SizeSlider_value_changed(value : float) -> void:
	onready_paths.preview.rect_min_size = STANDARD_SIZE * value
	onready_paths.preview.rect_scale = Vector2.ONE * value
	if(onready_paths.size_edit.text != "%f" % value):
		onready_paths.size_edit.set_text("%f" % value )
	SettingsUtils.set_crosshair_size(value)

func _on_SignalManager_update_settings() -> void:
	_init_current_crosshair()

func _on_SignalManager_translation_updated() -> void:
	_init_tr()