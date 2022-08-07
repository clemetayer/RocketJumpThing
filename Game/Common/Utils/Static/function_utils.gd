extends Reference
class_name FunctionUtils
# Functions that are usefull pretty much anywhere. mostly to reduce code redundancy


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


#### Maths and vectors #####
# chacks if a value is between an epsilon (strictly)
static func check_in_epsilon(value: float, compare: float, epsilon: float) -> bool:
	return value < compare + epsilon && value > compare - epsilon
