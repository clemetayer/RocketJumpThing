extends RigidBody
# A RigidBody platform, to switch easily from a static body to a rigid "physical" body

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	mode = RigidBody.MODE_STATIC

##### SIGNAL MANAGEMENT #####
func use() -> void:
	mode = RigidBody.MODE_RIGID
