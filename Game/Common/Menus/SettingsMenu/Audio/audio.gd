extends MarginContainer
# Audio settings

##### VARIABLES #####
#---- CONSTANTS -----
const VOLUME_TEXT := "%d%%"  # label displaying the volume
const TAB_NAME := "SETTINGS_AUDIO_MAIN_CATEGORY"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"main":
	{
		"category": $"AudioVBox/Main",
		"label": $"AudioVBox/Main/HBox/Label",
		"slider": $"AudioVBox/Main/HBox/Slider",
		"volume_label": $"AudioVBox/Main/HBox/Volume",
		"unmute": $"AudioVBox/Main/HBox/Mute"
	},
	"BGM":
	{
		"category": $"AudioVBox/BGM",
		"label": $"AudioVBox/BGM/HBox/Label",
		"slider": $"AudioVBox/BGM/HBox/Slider",
		"volume_label": $"AudioVBox/BGM/HBox/Volume",
		"unmute": $"AudioVBox/BGM/HBox/Mute"
	},
	"effects":
	{
		"category": $"AudioVBox/Effects",
		"label": $"AudioVBox/Effects/HBox/Label",
		"slider": $"AudioVBox/Effects/HBox/Slider",
		"volume_label": $"AudioVBox/Effects/HBox/Volume",
		"unmute": $"AudioVBox/Effects/HBox/Mute"
	}
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_connect_signals()
	_init_values()


##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.main.category.set_category_name(tr(TranslationKeys.SETTINGS_AUDIO_MAIN_CATEGORY))
	onready_paths.main.label.text = tr(TranslationKeys.SETTINGS_AUDIO_MAIN_LABEL)
	onready_paths.BGM.category.set_category_name(tr(TranslationKeys.SETTINGS_AUDIO_BGM_CATEGORY))
	onready_paths.BGM.label.text = tr(TranslationKeys.SETTINGS_AUDIO_BGM_LABEL)
	onready_paths.effects.category.set_category_name(
		tr(TranslationKeys.SETTINGS_AUDIO_EFFECTS_CATEGORY)
	)
	onready_paths.effects.label.text = tr(TranslationKeys.SETTINGS_AUDIO_EFFECTS_LABEL)
	onready_paths.main.unmute.hint_tooltip = tr(TranslationKeys.SETTINGS_AUDIO_MUTE_TOOLTIP)
	onready_paths.BGM.unmute.hint_tooltip = tr(TranslationKeys.SETTINGS_AUDIO_MUTE_TOOLTIP)
	onready_paths.effects.unmute.hint_tooltip = tr(TranslationKeys.SETTINGS_AUDIO_MUTE_TOOLTIP)


func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.main.slider, self, "value_changed", "_on_MainSlider_value_changed"
	)
	DebugUtils.log_connect(onready_paths.main.unmute, self, "toggled", "_on_MainUnmute_toggled")
	DebugUtils.log_connect(
		onready_paths.BGM.slider, self, "value_changed", "_on_BGMSlider_value_changed"
	)
	DebugUtils.log_connect(onready_paths.BGM.unmute, self, "toggled", "_on_BGMUnmute_toggled")
	DebugUtils.log_connect(
		onready_paths.effects.slider, self, "value_changed", "_on_EffectsSlider_value_changed"
	)
	DebugUtils.log_connect(
		onready_paths.effects.unmute, self, "toggled", "_on_EffectsUnmute_toggled"
	)


func _init_values() -> void:
	# Main
	onready_paths.main.slider.value = (
		db2linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))
		)
		* onready_paths.main.slider.max_value
	)
	onready_paths.main.volume_label.text = (
		VOLUME_TEXT
		% (
			db2linear(
				AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))
			)
			* onready_paths.main.slider.max_value
		)
	)
	onready_paths.main.unmute.pressed = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS)
	)
	onready_paths.main.slider.editable = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS)
	)
	# BGM
	onready_paths.BGM.slider.value = (
		db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS)))
		* onready_paths.BGM.slider.max_value
	)
	onready_paths.BGM.volume_label.text = (
		VOLUME_TEXT
		% (
			db2linear(
				AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))
			)
			* onready_paths.BGM.slider.max_value
		)
	)
	onready_paths.BGM.unmute.pressed = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.BGM_BUS)
	)
	onready_paths.BGM.slider.editable = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.BGM_BUS)
	)
	# Effects
	onready_paths.effects.slider.value = (
		db2linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))
		)
		* onready_paths.effects.slider.max_value
	)
	onready_paths.effects.volume_label.text = (
		VOLUME_TEXT
		% (
			db2linear(
				AudioServer.get_bus_volume_db(
					AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS)
				)
			)
			* onready_paths.effects.slider.max_value
		)
	)
	onready_paths.effects.unmute.pressed = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS)
	)
	onready_paths.effects.slider.editable = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS)
	)


##### SIGNAL MANAGEMENT #####
func _on_MainSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS),
		linear2db(value / onready_paths.main.slider.max_value)
	)
	onready_paths.main.volume_label.text = VOLUME_TEXT % value


func _on_MainUnmute_toggled(toggled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), not toggled)
	onready_paths.main.slider.editable = toggled


func _on_BGMSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.BGM_BUS),
		linear2db(value / onready_paths.BGM.slider.max_value)
	)
	onready_paths.BGM.volume_label.text = VOLUME_TEXT % value


func _on_BGMUnmute_toggled(toggled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS), not toggled)
	onready_paths.BGM.slider.editable = toggled


func _on_EffectsSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS),
		linear2db(value / onready_paths.effects.slider.max_value)
	)
	onready_paths.effects.volume_label.text = VOLUME_TEXT % value


func _on_EffectsUnmute_toggled(toggled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), not toggled)
	onready_paths.effects.slider.editable = toggled
