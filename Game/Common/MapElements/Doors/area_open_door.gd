extends Collidable
# An area to open a door on body entered trigger

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal trigger

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
var is_test := false  # boolean to tell if this is a test class, to avoid errors when it frees itself during the test


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	if connect("body_entered", self, "_on_area_open_door_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_area_open_door_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


##### SIGNAL MANAGEMENT #####
func _on_area_open_door_body_entered(body):
	if FunctionUtils.is_player(body):
		emit_signal("trigger")
		if !is_test:
			self.queue_free()  # Optionnal ?
