extends Resource
class_name ShakeVariable
# A simple resource for a variable that can be shaken
# mostly used in the var_shaker thing

##### VARIABLES #####
#---- EXPORTS -----
var object: Object
var property: String
var original_value


##### PROCESSING #####
# Called when the object is initialized.
func _init(p_object = null, p_property = "", p_original_value = null):
	object = p_object
	property = p_property
	original_value = p_original_value


##### PUBLIC METHODS #####
# returns true if this ShakeVariable can be used safely
func is_valid() -> bool:
	# TODO : find a way to add property in object with subresources paths
	return object != null
