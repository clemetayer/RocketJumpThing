extends MarginContainer
# General settings

##### VARIABLES #####
#---- CONSTANTS -----
const TAB_NAME := "MENU_SETTINGS_TAB_GENERAL"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"language":
	{
		"category": $"VBox/LanguageCategory",
		"label": $"VBox/LanguageCategory/LanguageHBox/LanguageLabel",
		"options": $"VBox/LanguageCategory/LanguageHBox/LanguageOptions"
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
	onready_paths.language.options.hint_tooltip = tr(TranslationKeys.SETTINGS_GENERAL_LANGUAGE_TOOLTIP)


func _init_options() -> void:
	var locales := TranslationServer.get_loaded_locales()
	for locale_idx in range(locales.size()):
		onready_paths.language.options.add_item(
			TranslationServer.get_locale_name(locales[locale_idx]), locale_idx
		)
		if locales[locale_idx] == TranslationServer.get_locale():
			onready_paths.language.options.select(locale_idx)

func _select_current_locale() -> void:
	var locales := TranslationServer.get_loaded_locales()
	for locale_idx in range(locales.size()):
		if locales[locale_idx] == TranslationServer.get_locale():
			onready_paths.language.options.select(locale_idx)

func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.language.options, self, "item_selected", "_on_Options_item_selected"
	)
	DebugUtils.log_connect(SignalManager, self, SignalManager.UPDATE_SETTINGS, "_on_SignalManager_update_settings")
	DebugUtils.log_connect(SignalManager, self, SignalManager.TRANSLATION_UPDATED, "_on_SignalManager_translation_updated")


##### SIGNAL MANAGEMENT #####
func _on_Options_item_selected(idx: int) -> void:
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[idx])  # Refactor : maybe dangerous ?
	SignalManager.emit_translation_updated()

func _on_SignalManager_update_settings() -> void:
	_select_current_locale()

func _on_SignalManager_translation_updated() -> void:
	_init_tr()