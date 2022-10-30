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
	if caller.connect(caller_signal_name, receiver, receiver_func_name) != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [caller_signal_name, receiver_func_name, print_stack_trace(get_stack())]
			)
		)


static func log_regex_compile(regex: RegEx, pattern: String) -> void:
	if regex.compile(pattern) != OK:
		Logger.error(
			(
				"Error while compiling pattern : %s on regex, at %s"
				% [pattern, print_stack_trace(get_stack())]
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
