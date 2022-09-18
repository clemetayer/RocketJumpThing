extends Collidable
# A solid entity that rotates

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if properties.has("rotation_speeds"):
		rotate_x(properties["rotation_speeds"].x * delta)
		rotate_y(properties["rotation_speeds"].y * delta)
		rotate_z(properties["rotation_speeds"].z * delta)
