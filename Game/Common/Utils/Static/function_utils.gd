extends Reference
class_name FunctionUtils
# Functions that are usefull pretty much anywhere. mostly to reduce code redundancy

#### Variables & Consts #####
const REGEX_COLOR_PATTERN := "#[0-9a-fA-F]{6,6}"


#### Logger #####
# connects and logs if it fails
# TODO : switch this to DebugUtils ?
static func log_connect(caller, receiver, caller_signal_name: String, receiver_func_name: String):
	if caller.connect(caller_signal_name, receiver, receiver_func_name) != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					caller_signal_name,
					receiver_func_name,
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


static func log_regex_compile(regex: RegEx, pattern: String) -> void:
	if regex.compile(pattern) != OK:
		Logger.error(
			(
				"Error while compiling pattern : %s on regex, at %s"
				% [pattern, DebugUtils.print_stack_trace(get_stack())]
			)
		)


#### Maths and vectors #####
# chacks if a value is between an epsilon (strictly)
static func check_in_epsilon(value: float, compare: float, epsilon: float) -> bool:
	return value < compare + epsilon && value > compare - epsilon


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


static func _json_data_to_objects(dict: Dictionary) -> Dictionary:
	for key in dict:
		if dict[key] is Dictionary and not dict[key] is Array:
			dict[key] = _json_data_to_objects(dict[key])
		elif dict[key] is String:
			var regex = RegEx.new()
			log_regex_compile(regex, REGEX_COLOR_PATTERN)
			if regex.search(dict[key]) != null:
				dict[key] = Color(dict[key])
	return dict
