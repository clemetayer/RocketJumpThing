extends Collidable
# Area to check the speed before breaking the associated wall

##### SIGNALS #####
signal trigger

#---- STANDARD -----
#==== PRIVATE ====
var _treshold := 100.0  # treshold speed for the wall to break (greater or equal)


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if connect("body_entered", self, "_on_breakable_area_speed_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_breakable_area_speed_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	.update_properties()
	if 'treshold' in properties and is_inside_tree():
		self._treshold = properties.treshold


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_body_entered(body):
	if body.is_in_group("player") and body.current_speed >= _treshold:
		emit_signal("trigger")
		self.queue_free()
