extends Collidable
# Standard door that simply goes to the specified direction on trigger of an external event

##### ENUMS #####
enum state { closed, opened }

##### VARIABLES #####
#---- CONSTANTS -----
const TB_STANDARD_DOOR_MAPPER := [["open_position", "_open_position"], ["open_time", "_open_time"]]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _open_position: Vector3  # Final position after opening (from current self position)
var _open_time: float  # Time to open
var _opening := false  # True if the door is opening
var _state: int = state.closed  # state of the door (closed by default)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_STANDARD_DOOR_MAPPER)


# triggers the opening of the door
func _open() -> void:
	if not _opening and not _state == state.opened:
		var tween := Tween.new()
		add_child(tween)
		DebugUtils.log_tween_interpolate_property(
			tween, self, "translation", translation, translation + _open_position, _open_time
		)
		DebugUtils.log_tween_start(tween)
		_opening = true
		yield(tween, "tween_all_completed")
		_opening = false
		_state = state.opened
		tween.queue_free()
		if "free_on_open" in properties and properties.free_on_open:
			queue_free()


##### SIGNAL MANAGEMENT #####
#==== Qodot =====
func use() -> void:
	_open()
