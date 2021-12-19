extends Collidable
# An area that triggers a tutorial on player entered

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _key: String
var _time: float


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if connect("body_entered", self, "_on_area_tutotial_trigger_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_area_tutotial_trigger_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


# Called when the node enters the scene tree for the first time.
func _ready():
	if 'key' in properties:
		self._key = properties.key
	if 'time' in properties:
		self._time = properties.time


##### SIGNAL MANAGEMENT #####
func _on_area_tutotial_trigger_body_entered(body):
	if body.is_in_group("player"):
		SignalManager.emit_trigger_tutorial(_key, _time)
		self.queue_free()
