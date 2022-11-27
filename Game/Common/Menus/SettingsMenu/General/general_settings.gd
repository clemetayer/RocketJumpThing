extends VBoxContainer
# General settings

##### VARIABLES #####
#---- CONSTANTS -----
const TAB_NAME := "General"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"language":
	{
		"category": $"LanguageCategory",
		"label": $"LanguageCategory/LanguageHBox/LanguageLabel",
		"options": $"LanguageCategory/LanguageHBox/LanguageOptions"
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_init_options()
	_connect_signals()


##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.language.label.text = tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_OPTION)
	onready_paths.language.category.set_category_name(
		tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_CATEGORY)
	)


func _init_options() -> void:
	var locales := TranslationServer.get_loaded_locales()
	for locale_idx in range(locales.size()):
		onready_paths.language.options.add_item(
			TranslationServer.get_locale_name(locales[locale_idx]), locale_idx
		)
		if locales[locale_idx] == TranslationServer.get_locale():
			onready_paths.language.options.select(locale_idx)


func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.language.options, self, "item_selected", "_on_Options_item_selected"
	)


##### SIGNAL MANAGEMENT #####
func _on_Options_item_selected(idx: int) -> void:
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[idx])  # Refactor : maybe dangerous ?
