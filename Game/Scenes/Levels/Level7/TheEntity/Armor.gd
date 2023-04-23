tool
extends MeshInstance
# Simple rotating mesh script

##### VARIABLES #####
#---- CONSTANTS -----
const ROTATION_SPEED := Vector3(1,2,3)


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	self.rotation += ROTATION_SPEED * delta
