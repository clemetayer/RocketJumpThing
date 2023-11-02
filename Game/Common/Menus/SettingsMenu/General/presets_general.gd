extends Presets
# A preset for the controls class


##### PROTECTED METHODS #####
# Overriden from parent
func _generate_cfg_file() -> ConfigFile:
	return SettingsUtils.generate_cfg_general_file()


# Overriden from parent
func _get_init_selected_cfg() -> String:
	return SettingsUtils.settings_presets.general


# Overriden from parent
func _get_config_path() -> String:
	return SettingsUtils.GENERAL_PRESETS_PATH


# Overriden from parent, applies the selected cfg file preset
func _apply_preset(path: String) -> void:
	SettingsUtils.load_general_cfg(DebugUtils.log_load_cfg(path))
	SettingsUtils.settings_presets.general = _get_cfg_name()
