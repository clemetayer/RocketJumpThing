extends MarginContainer
# Audio settings

##### VARIABLES #####
#---- CONSTANTS -----
const VOLUME_TEXT := "%d%%"  # label displaying the volume
const TAB_NAME := "Audio"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"main":
	{
		"slider": $"AudioVBox/Main/HBox/Slider",
		"volume_label": $"AudioVBox/Main/HBox/Volume",
		"mute": $"AudioVBox/Main/HBox/Mute"
	},
	"BGM":
	{
		"slider": $"AudioVBox/BGM/HBox/Slider",
		"volume_label": $"AudioVBox/BGM/HBox/Volume",
		"mute": $"AudioVBox/BGM/HBox/Mute"
	},
	"effects":
	{
		"slider": $"AudioVBox/Effects/HBox/Slider",
		"volume_label": $"AudioVBox/Effects/HBox/Volume",
		"mute": $"AudioVBox/Effects/HBox/Mute"
	}
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_values()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.main.slider, self, "value_changed", "_on_MainSlider_value_changed"
	)
	DebugUtils.log_connect(onready_paths.main.mute, self, "toggled", "_on_MainMute_toggled")
	DebugUtils.log_connect(
		onready_paths.BGM.slider, self, "value_changed", "_on_BGMSlider_value_changed"
	)
	DebugUtils.log_connect(onready_paths.BGM.mute, self, "toggled", "_on_BGMMute_toggled")
	DebugUtils.log_connect(
		onready_paths.effects.slider, self, "value_changed", "_on_EffectsSlider_value_changed"
	)
	DebugUtils.log_connect(onready_paths.effects.mute, self, "toggled", "_on_EffectsMute_toggled")


func _init_values() -> void:
	# Main
	onready_paths.main.slider.value = (
		db2linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VariableManager.MAIN_BUS))
		)
		* onready_paths.main.slider.max_value
	)
	onready_paths.main.volume_label.text = (
		VOLUME_TEXT
		% (
			db2linear(
				AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VariableManager.MAIN_BUS))
			)
			* onready_paths.main.slider.max_value
		)
	)
	onready_paths.main.mute.pressed = AudioServer.is_bus_mute(
		AudioServer.get_bus_index(VariableManager.MAIN_BUS)
	)
	onready_paths.main.slider.editable = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(VariableManager.MAIN_BUS)
	)
	# BGM
	onready_paths.BGM.slider.value = (
		db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VariableManager.BGM_BUS)))
		* onready_paths.BGM.slider.max_value
	)
	onready_paths.BGM.volume_label.text = (
		VOLUME_TEXT
		% (
			db2linear(
				AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VariableManager.BGM_BUS))
			)
			* onready_paths.BGM.slider.max_value
		)
	)
	onready_paths.BGM.mute.pressed = AudioServer.is_bus_mute(
		AudioServer.get_bus_index(VariableManager.BGM_BUS)
	)
	onready_paths.BGM.slider.editable = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(VariableManager.BGM_BUS)
	)
	# Effects
	onready_paths.effects.slider.value = (
		db2linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VariableManager.EFFECTS_BUS))
		)
		* onready_paths.effects.slider.max_value
	)
	onready_paths.effects.volume_label.text = (
		VOLUME_TEXT
		% (
			db2linear(
				AudioServer.get_bus_volume_db(
					AudioServer.get_bus_index(VariableManager.EFFECTS_BUS)
				)
			)
			* onready_paths.effects.slider.max_value
		)
	)
	onready_paths.effects.mute.pressed = AudioServer.is_bus_mute(
		AudioServer.get_bus_index(VariableManager.EFFECTS_BUS)
	)
	onready_paths.effects.slider.editable = not AudioServer.is_bus_mute(
		AudioServer.get_bus_index(VariableManager.EFFECTS_BUS)
	)


##### SIGNAL MANAGEMENT #####
func _on_MainSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(VariableManager.MAIN_BUS),
		linear2db(value / onready_paths.main.slider.max_value)
	)
	onready_paths.main.volume_label.text = VOLUME_TEXT % value


func _on_MainMute_toggled(toggled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(VariableManager.MAIN_BUS), toggled)
	onready_paths.main.slider.editable = not toggled


func _on_BGMSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(VariableManager.BGM_BUS),
		linear2db(value / onready_paths.BGM.slider.max_value)
	)
	onready_paths.BGM.volume_label.text = VOLUME_TEXT % value


func _on_BGMMute_toggled(toggled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(VariableManager.BGM_BUS), toggled)
	onready_paths.BGM.slider.editable = not toggled


func _on_EffectsSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(VariableManager.EFFECTS_BUS),
		linear2db(value / onready_paths.effects.slider.max_value)
	)
	onready_paths.effects.volume_label.text = VOLUME_TEXT % value


func _on_EffectsMute_toggled(toggled: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(VariableManager.EFFECTS_BUS), toggled)
	onready_paths.effects.slider.editable = not toggled
