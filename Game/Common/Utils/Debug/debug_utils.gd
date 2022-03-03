extends Reference
class_name DebugUtils
# A class for debug purposes

##### PUBLIC METHODS #####
static func print_stack_trace(stack: Array) -> String:
	var ret_str := ""
	for el in stack:
		ret_str += "at %s, method %s, line %s" % [el.source, el.function, el.line]
	return ret_str
