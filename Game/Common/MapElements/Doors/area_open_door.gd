extends Collidable
class_name AreaOpenDoor
# An area to open a door on body entered trigger

##### SIGNALS #####
signal trigger


##### PROCESSING #####
# Called when the object is initialized.
func _init():
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
	if body.is_in_group("player"):
		emit_signal("trigger")
		self.queue_free()  # Optionnal ?