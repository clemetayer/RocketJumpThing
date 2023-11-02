extends Presets
# A preset for the controls class


##### PROTECTED METHODS #####
# Overriden from parent
func _generate_cfg_file() -> ConfigFile:
	return SettingsUtils.generate_cfg_audio_file()


# Overriden from parent
func _get_init_selected_cfg() -> String:
	return SettingsUtils.settings_presets.audio


# Overriden from parent
func _get_config_path() -> String:
	return SettingsUtils.AUDIO_PRESETS_PATH


# Overriden from parent, applies the selected cfg file preset
func _apply_preset(path: String) -> void:
	SettingsUtils.load_cfg_general_file(DebugUtils.log_load_cfg(path))
	SettingsUtils.settings_presets.audio = _get_cfg_name()
