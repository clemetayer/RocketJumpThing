# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests for the audio tab

##### VARIABLES #####
const FLOAT_APPROX := 0.5  # float approximation for dBs
const audio_path := "res://Game/Common/Menus/SettingsMenu/Audio/audio.tscn"
var audio


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = audio_path
	.before()
	audio = load(audio_path).instance()
	audio._ready()


func after():
	.after()
	audio.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_tr() -> void:
	audio._init_tr()
	# main
	assert_str(audio.onready_paths.main.category.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_AUDIO_MAIN_CATEGORY)
	)
	assert_str(audio.onready_paths.main.label.text).is_equal(
		tr(TranslationKeys.SETTINGS_AUDIO_MAIN_LABEL)
	)
	# BGM
	assert_str(audio.onready_paths.BGM.category.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_AUDIO_BGM_CATEGORY)
	)
	assert_str(audio.onready_paths.BGM.label.text).is_equal(
		tr(TranslationKeys.SETTINGS_AUDIO_BGM_LABEL)
	)
	# Effects
	assert_str(audio.onready_paths.effects.category.CATEGORY_NAME).is_equal(
		tr(TranslationKeys.SETTINGS_AUDIO_EFFECTS_CATEGORY)
	)
	assert_str(audio.onready_paths.effects.label.text).is_equal(
		tr(TranslationKeys.SETTINGS_AUDIO_EFFECTS_LABEL)
	)


func test_connect_signals() -> void:
	audio._connect_signals()
	# main
	assert_bool(audio.onready_paths.main.slider.is_connected("value_changed", audio, "_on_MainSlider_value_changed")).is_true()
	assert_bool(audio.onready_paths.main.mute.is_connected("toggled", audio, "_on_MainMute_toggled")).is_true()
	# bgm
	assert_bool(audio.onready_paths.BGM.slider.is_connected("value_changed", audio, "_on_BGMSlider_value_changed")).is_true()
	assert_bool(audio.onready_paths.BGM.mute.is_connected("toggled", audio, "_on_BGMMute_toggled")).is_true()
	# effects
	assert_bool(audio.onready_paths.effects.slider.is_connected("value_changed", audio, "_on_EffectsSlider_value_changed")).is_true()
	assert_bool(audio.onready_paths.effects.mute.is_connected("toggled", audio, "_on_EffectsMute_toggled")).is_true()


func test_init_values() -> void:
	# init
	## main
	var MAIN_AUDIO_VAL := -1.0
	var MAIN_AUDIO_MUTE := true
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), MAIN_AUDIO_VAL
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS), MAIN_AUDIO_MUTE)
	## BGM
	var BGM_AUDIO_VAL := -0.5
	var BGM_AUDIO_MUTE := false
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS), BGM_AUDIO_VAL)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS), BGM_AUDIO_MUTE)
	## main
	var EFFECTS_AUDIO_VAL := 0.0
	var EFFECTS_AUDIO_MUTE := true
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), EFFECTS_AUDIO_VAL
	)
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS), EFFECTS_AUDIO_MUTE
	)
	# tests
	audio._init_values()
	## main
	assert_float(audio.onready_paths.main.slider.value).is_equal_approx(
		db2linear(MAIN_AUDIO_VAL) * audio.onready_paths.main.slider.max_value, FLOAT_APPROX
	)
	assert_str(audio.onready_paths.main.volume_label.text).is_equal(
		audio.VOLUME_TEXT % (db2linear(MAIN_AUDIO_VAL) * audio.onready_paths.main.slider.max_value)
	)
	assert_bool(audio.onready_paths.main.mute.pressed).is_equal(MAIN_AUDIO_MUTE)
	assert_bool(audio.onready_paths.main.slider.editable).is_equal(not MAIN_AUDIO_MUTE)
	## bgm
	assert_float(audio.onready_paths.BGM.slider.value).is_equal_approx(
		db2linear(BGM_AUDIO_VAL) * audio.onready_paths.BGM.slider.max_value, FLOAT_APPROX
	)
	assert_str(audio.onready_paths.BGM.volume_label.text).is_equal(
		audio.VOLUME_TEXT % (db2linear(BGM_AUDIO_VAL) * audio.onready_paths.BGM.slider.max_value)
	)
	assert_bool(audio.onready_paths.BGM.mute.pressed).is_equal(BGM_AUDIO_MUTE)
	assert_bool(audio.onready_paths.BGM.slider.editable).is_equal(not BGM_AUDIO_MUTE)
	## effects
	assert_float(audio.onready_paths.effects.slider.value).is_equal_approx(
		db2linear(EFFECTS_AUDIO_VAL) * audio.onready_paths.effects.slider.max_value, FLOAT_APPROX
	)
	assert_str(audio.onready_paths.effects.volume_label.text).is_equal(
		(
			audio.VOLUME_TEXT
			% (db2linear(EFFECTS_AUDIO_VAL) * audio.onready_paths.effects.slider.max_value)
		)
	)
	assert_bool(audio.onready_paths.effects.mute.pressed).is_equal(EFFECTS_AUDIO_MUTE)
	assert_bool(audio.onready_paths.effects.slider.editable).is_equal(not EFFECTS_AUDIO_MUTE)


# Main
func test_on_MainSlider_value_changed() -> void:
	var VOLUME := 51.2  # %
	audio._on_MainSlider_value_changed(VOLUME)
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))).is_equal_approx(
		linear2db(VOLUME / audio.onready_paths.main.slider.max_value), FLOAT_APPROX
	)
	assert_str(audio.onready_paths.main.volume_label.text).is_equal(audio.VOLUME_TEXT % VOLUME)


func test_on_MainMute_toggled() -> void:
	var MUTE := false
	audio._on_MainMute_toggled(MUTE)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.MAIN_BUS))).is_equal(
		MUTE
	)
	assert_bool(audio.onready_paths.main.slider.editable).is_equal(not MUTE)


# BGM
func test_on_BGMSlider_value_changed() -> void:
	var VOLUME := 51.3  # %
	audio._on_BGMSlider_value_changed(VOLUME)
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))).is_equal_approx(
		linear2db(VOLUME / audio.onready_paths.BGM.slider.max_value), FLOAT_APPROX
	)
	assert_str(audio.onready_paths.BGM.volume_label.text).is_equal(audio.VOLUME_TEXT % VOLUME)


func test_on_BGMMute_toggled() -> void:
	var MUTE := true
	audio._on_BGMMute_toggled(MUTE)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.BGM_BUS))).is_equal(
		MUTE
	)
	assert_bool(audio.onready_paths.BGM.slider.editable).is_equal(not MUTE)


# Effects
func test_on_EffectsSlider_value_changed() -> void:
	var VOLUME := 51.4  # %
	audio._on_EffectsSlider_value_changed(VOLUME)
	assert_float(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))).is_equal_approx(
		linear2db(VOLUME / audio.onready_paths.effects.slider.max_value), FLOAT_APPROX
	)
	assert_str(audio.onready_paths.effects.volume_label.text).is_equal(audio.VOLUME_TEXT % VOLUME)


func test_on_EffectsMute_toggled() -> void:
	var MUTE := false
	audio._on_EffectsMute_toggled(MUTE)
	assert_bool(AudioServer.is_bus_mute(AudioServer.get_bus_index(GlobalConstants.EFFECTS_BUS))).is_equal(
		MUTE
	)
	assert_bool(audio.onready_paths.effects.slider.editable).is_equal(not MUTE)
