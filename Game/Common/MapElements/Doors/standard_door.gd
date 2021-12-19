extends StaticBody
class_name StandardDoor
# Standard door that simply goes to the specified direction on trigger of an external event

##### ENUMS #####
enum state { closed, opened }

##### VARIABLES #####
#---- EXPORTS -----
export (Dictionary) var properties setget set_properties

#---- STANDARD -----
#==== PRIVATE ====
var _open_position: Vector3  # Final position after opening (from current self position)
var _open_time: float  # Time to open
var _opening := false  # True if the door is opening
var _state: int = state.closed  # state of the door (closed by default)


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	if 'open_position' in properties:
		self._open_position = properties.open_position
	if 'open_time' in properties:
		self._open_time = properties.open_time


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'collision_layer' in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if 'collision_mask' in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask


#==== Other =====
# triggers the opening of the door
func _open() -> void:
	if not _opening and not _state == state.opened:
		var tween := Tween.new()
		add_child(tween)
		if ! tween.interpolate_property(
			self, "translation", translation, translation + _open_position, _open_time
		):
			Logger.error(
				(
					"Error while setting tween interpolate property %s at %s"
					% ["translation", DebugUtils.print_stack_trace(get_stack())]
				)
			)
		if ! tween.start():
			Logger.error(
				"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
			)
		_opening = true
		yield(tween, "tween_all_completed")
		_opening = false
		_state = state.opened
		tween.queue_free()


##### SIGNAL MANAGEMENT #####
#==== Qodot =====
func use() -> void:
	_open()
