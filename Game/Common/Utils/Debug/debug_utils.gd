extends Reference
class_name DebugUtils
# A class for debug purposes

##### ENUMS #####
enum LOG_LEVEL { info, fine, trace, debug, warn, error, fatal }


##### PUBLIC METHODS #####
static func log_stacktrace(message: String, log_level: int) -> void:
	var message_with_stacktrace = message + ", at %s" % [print_stack_trace(get_stack())]
	match log_level:
		LOG_LEVEL.info:
			Logger.info(message_with_stacktrace)
		LOG_LEVEL.fine:
			Logger.fine(message_with_stacktrace)
		LOG_LEVEL.trace:
			Logger.trace(message_with_stacktrace)
		LOG_LEVEL.debug:
			Logger.debug(message_with_stacktrace)
		LOG_LEVEL.warn:
			Logger.warn(message_with_stacktrace)
		LOG_LEVEL.error:
			Logger.error(message_with_stacktrace)
		LOG_LEVEL.fatal:
			Logger.fatal(message_with_stacktrace)


static func print_stack_trace(stack: Array) -> String:
	var ret_str := ""
	for el in stack:
		ret_str += "%s, method %s, line %s, at\n" % [el.source, el.function, el.line]
	return ret_str


#### Logger #####
# connects and logs if it fails
static func log_connect(caller, receiver, caller_signal_name: String, receiver_func_name: String):
	if caller != null and receiver != null:
		var error = caller.connect(caller_signal_name, receiver, receiver_func_name)
		if error != OK:
			log_stacktrace(
				(
					"Error connecting %s to %s, with error %d"
					% [caller_signal_name, receiver_func_name, error]
				),
				LOG_LEVEL.error
			)
	else:
		log_stacktrace(
			(
				"Error connecting %s to %s, one of the part is null - %s -> %s"
				% [caller_signal_name, receiver_func_name, caller, receiver]
			),
			LOG_LEVEL.error
		)


static func log_regex_compile(regex: RegEx, pattern: String) -> void:
	var error = regex.compile(pattern)
	if error != OK:
		log_stacktrace(
			"Error %d while compiling pattern : %s on regex" % [error, pattern], LOG_LEVEL.error
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
		log_stacktrace(
			"Error while setting tween interpolate property %s" % [variable], LOG_LEVEL.error
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
		log_stacktrace(
			"Error while setting tween interpolate method %s" % [method], LOG_LEVEL.error
		)


static func log_tween_start(tween: Tween) -> void:
	if !tween.start():
		log_stacktrace("Error when starting tween", LOG_LEVEL.error)


static func log_tween_stop_all(tween: Tween) -> void:
	if !tween.stop_all():
		log_stacktrace("Error when stopping all tween properties and methods", LOG_LEVEL.error)


static func log_load_cfg(path: String) -> ConfigFile:
	var config_file := ConfigFile.new()
	var error = config_file.load(path)
	if error != OK:
		log_stacktrace(
			"Error loading config file at %s, with error %d" % [path, error], LOG_LEVEL.error
		)
	return config_file


static func log_save_cfg(config_file: ConfigFile, path: String) -> void:
	_create_empty_file(path)
	var error := config_file.save(path)
	if error != OK:
		log_stacktrace(
			"Error while saving the cfg file at %s with error %d" % [path, error], LOG_LEVEL.error
		)


static func log_load_resource(path: String) -> Resource:
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path)
	log_stacktrace("Error while loading the resource at %s" % [path], LOG_LEVEL.error)
	return Resource.new()


static func log_save_resource(resource: Resource, path: String) -> void:
	_create_empty_file(path)
	var error := ResourceSaver.save(path, resource)
	if error != OK:
		log_stacktrace(
			"Error while saving the resource %s at %s. Error %d" % [resource, path, error],
			LOG_LEVEL.error
		)


static func log_create_directory(path: String) -> void:
	var dir := Directory.new()
	var error := dir.make_dir_recursive(path)
	if error != OK:
		log_stacktrace(
			"Error while creating the directory at %s with error %d" % [path, error],
			LOG_LEVEL.error
		)


static func log_shell_open(cmd: String) -> void:
	var error = OS.shell_open(cmd)
	if error != OK:
		log_stacktrace("Error on shell_open with command %s" % [cmd], LOG_LEVEL.error)


static func _create_empty_file(path: String) -> void:
	# creates the file if it does not exist
	var file = File.new()
	if not file.file_exists(path):
		file.open(path, File.WRITE)
		file.store_string(" ")  # Stores an (almost) empty string to create the file
	file.close()
