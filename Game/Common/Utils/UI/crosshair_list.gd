tool
extends Resource
class_name CrosshairList
# kind of a weird workaround to "force" crosshairs to be detected by the engine on export

##### VARIABLES #####
#---- CONSTANTS -----
const CROSSHAIR_FOLDER := "res://Misc/UI/Crosshairs/PNG/WhiteRetina/"

#---- EXPORTS -----
export(bool) var FILL_CROSSHAIRS setget _set_fill_crosshairs
export(Array) var CROSSHAIRS


##### PROTECTED METHODS #####
# I won't set the array manually, come on, there are 200 crosshairs...
func _set_fill_crosshairs(value : bool) -> void:
	if Engine.editor_hint:
		CROSSHAIRS = []
		var crosshair_file_names = FunctionUtils.list_dir_files(CROSSHAIR_FOLDER,SettingsUtils.REGEX_PATTERN_PNG_FILE)
		crosshair_file_names.sort()
		for file_name in crosshair_file_names:
			var crosshair_data = {
				"image":null,
				"name":"",
				"path":""
			}
			crosshair_data.name = file_name.split(".")[0]
			crosshair_data.image = FunctionUtils.get_texture_at_path(CROSSHAIR_FOLDER + file_name, Vector2(20,20))
			crosshair_data.path = CROSSHAIR_FOLDER + file_name
			CROSSHAIRS.append(crosshair_data)
	value = false
	FILL_CROSSHAIRS = value