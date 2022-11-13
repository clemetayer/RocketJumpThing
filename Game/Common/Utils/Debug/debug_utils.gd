extends Reference
class_name DebugUtils
# A class for debug purposes


##### PUBLIC METHODS #####
static func print_stack_trace(stack: Array) -> String:
	var ret_str := ""
	for el in stack:
		ret_str += "%s, method %s, line %s, at\n" % [el.source, el.function, el.line]
	return ret_str


#### Logger #####
# connects and logs if it fails
static func log_connect(caller, receiver, caller_signal_name: String, receiver_func_name: String):
	var error = caller.connect(caller_signal_name, receiver, receiver_func_name)
	if error != OK:
		Logger.error(
			(
				"Error connecting %s to %s, with error %d in %s"
				% [caller_signal_name, receiver_func_name, error, print_stack_trace(get_stack())]
			)
		)


static func log_regex_compile(regex: RegEx, pattern: String) -> void:
	var error = regex.compile(pattern)
	if error != OK:
		Logger.error(
			(
				"Error %d while compiling pattern : %s on regex, at %s"
				% [error, pattern, print_stack_trace(get_stack())]
			)
		)


static func log_tween_interpolate_property(
	tween: Tween,
	target: Object,
	variable: String,
	start_value,
	end_value,
	time: float,
	trans_type: int = 0,
	ease_type: int = 0,
	delay: float = 0
) -> void:
	if !tween.interpolate_property(
		target, variable, start_value, end_value, time, trans_type, ease_type, delay
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% [variable, print_stack_trace(get_stack())]
			)
		)


static func log_tween_interpolate_method(
	tween: Tween,
	target: Object,
	method: String,
	start_value,
	end_value,
	time: float,
	trans_type: int = 0,
	ease_type: int = 2,
	delay: float = 0
) -> void:
	if !tween.interpolate_method(
		target, method, start_value, end_value, time, trans_type, ease_type, delay
	):
		Logger.error(
			(
				"Error while setting tween interpolate method %s at %s"
				% [method, print_stack_trace(get_stack())]
			)
		)


static func log_tween_start(tween: Tween) -> void:
	if !tween.start():
		Logger.error("Error when starting tween at %s" % [print_stack_trace(get_stack())])


static func log_tween_stop_all(tween: Tween) -> void:
	if !tween.stop_all():
		Logger.error(
			(
				"Error when stopping all tween properties and methods at %s"
				% [print_stack_trace(get_stack())]
			)
		)


static func log_load_cfg(path: String) -> ConfigFile:
	var config_file := ConfigFile.new()
	var error = config_file.load(path)
	if error != OK:
		Logger.error(
			(
				"Error loading config file at %s, with error %d at %s"
				% [path, error, print_stack_trace(get_stack())]
			)
		)
	return config_file


static func log_save_cfg(config_file: ConfigFile, path: String) -> void:
	# creates the file if it does not exist
	var file = File.new()
	if not file.file_exists(path):
		file.open(path, File.WRITE)
		file.store_string(" ")  # Stores an (almost) empty string to create the file
	file.close()
	var error := config_file.save(path)
	if error != OK:
		Logger.error(
			(
				"Error while saving the cfg file at %s with error %d, at %s"
				% [path, error, print_stack_trace(get_stack())]
			)
		)


static func log_create_directory(path: String) -> void:
	var dir := Directory.new()
	var error := dir.make_dir_recursive(path)
	if error != OK:
		Logger.error(
			(
				"Error while creating the directory at %s with error %d, at %s"
				% [path, error, print_stack_trace(get_stack())]
			)
		)


static func log_shell_open(cmd: String) -> void:
	var error = OS.shell_open(cmd)
	if error != OK:
		Logger.error(
			"Error on shell_open with command %s, at %s" % [cmd, print_stack_trace(get_stack())]
		)
