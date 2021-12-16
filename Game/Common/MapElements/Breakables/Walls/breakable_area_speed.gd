extends Area
# Area to check the speed before breaking the associated wall

##### SIGNALS #####
signal trigger

##### VARIABLES #####
#---- EXPORTS -----
export (Dictionary) var properties setget set_properties

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
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'collision_layer' in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if 'collision_mask' in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask
	if 'treshold' in properties and is_inside_tree():
		self._treshold = properties.treshold


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_body_entered(body):
	if body.is_in_group("player") and body.current_speed >= _treshold:
		emit_signal("trigger")
		self.queue_free()
