extends Collidable
# An area to enable or disable some of the player's abilities

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _abilities := {}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	# trenchbroom init
	if properties.has("abilities"):
		var json = JSON.parse(properties["abilities"].c_unescape())  # I don't especially like danger, but it's more convenient this way
		if json.error == OK:
			_abilities = json.result
		else:
			Logger.error(
				(
					"Error on attempting to parse json for %s. Error %d, %s at line %d; %s"
					% [
						properties["abilities"],
						json.error,
						json.error_string,
						json.error_line,
						DebugUtils.print_stack_trace(get_stack())
					]
				)
			)


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		for element in _abilities.keys():
			if typeof(element) == TYPE_STRING and typeof(_abilities[element]) == TYPE_BOOL:
				body.toggle_ability(element, _abilities[element])
