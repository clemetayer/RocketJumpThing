extends Reference
class_name FunctionUtils
# Functions that are usefull pretty much anywhere. mostly to reduce code redundancy

#### Variables & Consts #####
const REGEX_COLOR_PATTERN := "#[0-9a-fA-F]{6,6}"
const PORTAL_PROCESS_METHOD_NAME := "portal_process"


#### Maths and vectors #####
# chacks if a value is between an epsilon (strictly)
static func check_in_epsilon(value: float, compare: float, epsilon: float, equals: bool = false) -> bool:
	return (
		(value < compare + epsilon and value > compare - epsilon)
		or (equals and (value == compare + epsilon or value == compare - epsilon))
	)


#### Read and write #####
# loads a json file as an object
static func load_json(path: String) -> Dictionary:
	var file = File.new()
	var data = null
	if file.file_exists(path):
		file.open(path, File.READ)
		data = _json_data_to_objects(parse_json(file.get_as_text()))
	else:
		Logger.error(
			"Failed to load json %s at %s" % [path, DebugUtils.print_stack_trace(get_stack())]
		)
	file.close()
	return data


static func parse_json_string_to_objects(json_str: String) -> Dictionary:
	var dict := {}
	if json_str != null and not json_str.empty():
		var parsed_json = parse_json(json_str)
		if parsed_json != null:
			dict = _json_data_to_objects(parsed_json)
		else:
			Logger.error(
				(
					"Failed to load json %s at %s"
					% [json_str, DebugUtils.print_stack_trace(get_stack())]
				)
			)
	else:
		Logger.error("json parameter is empty, at %s" % DebugUtils.print_stack_trace(get_stack()))
	return dict


# TODO : Case if an array contains another array
static func _json_data_to_objects(dict: Dictionary) -> Dictionary:
	for key in dict:
		if dict[key] is Dictionary and not dict[key] is Array:
			dict[key] = _json_data_to_objects(dict[key])
		elif dict[key] is Array:
			for array_idx in range(0, dict[key].size()):
				if dict[key][array_idx] is Dictionary:
					dict[key][array_idx] = _json_data_to_objects(dict[key][array_idx])
				else:
					dict[key][array_idx] = _map_to_object(dict[key][array_idx])
		else:
			dict[key] = _map_to_object(dict[key])
	return dict


# converts a string or json element with a specific regexp to an object
static func _map_to_object(el):
	if el is String:
		var regex = RegEx.new()
		DebugUtils.log_regex_compile(regex, REGEX_COLOR_PATTERN)
		if regex.search(el) != null:
			return Color(el)
		else:
			return str2var(el)
	else:
		return el


# lists the filenames in a directory at path
# from https://docs.godotengine.org/en/stable/classes/class_directory.html with some tweaks
static func list_dir_files(path: String, regex_pattern: String = "*") -> Array:
	var dir = Directory.new()
	var regex := RegEx.new()
	var file_list := []
	DebugUtils.log_regex_compile(regex, regex_pattern)
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and regex.search(file_name):  # file and not directory + matches regex_pattern
				file_list.append(file_name)
			file_name = dir.get_next()
	else:
		Logger.error(
			"No folder found at path %s, at %s" % [path, DebugUtils.print_stack_trace(get_stack())]
		)
	return file_list


#### Song manager #####
static func create_filter_auto_effect(fade_time: float) -> EffectManager:
	var effect = HalfFilterEffectManager.new()
	effect.TIME = fade_time
	return effect


#### Body identification #####
static func is_player(body: Node) -> bool:
	return body != null && body.is_in_group(GlobalConstants.PLAYER_GROUP)


static func is_rocket(area: Area) -> bool:
	return area != null && area.is_in_group("rocket")


static func is_start_point(checkpoint: Area) -> bool:
	return checkpoint != null && checkpoint.is_in_group(GlobalConstants.START_POINT_GROUP)


static func is_laser(laser: Area) -> bool:
	return laser != null && laser.is_in_group(GlobalConstants.LASER_GROUP)


static func is_portal_compatible(element: Node) -> bool:
	return (
		element != null
		&& element is Spatial
		&& element.has_method(PORTAL_PROCESS_METHOD_NAME)
		&& element.is_in_group("portal_compatible")
	)


#### String control #####
static func scene_path_valid(scene_path: String) -> bool:
	return scene_path != null and not scene_path.empty() and ResourceLoader.exists(scene_path)
