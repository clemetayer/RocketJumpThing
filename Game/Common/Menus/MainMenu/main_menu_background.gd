extends Spatial
# Main menu background script

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"camera_focus":$"CameraFocus"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_skybox()

##### PROTECTED METHODS #####
func _init_skybox() -> void:
	var skyboxes = get_tree().get_nodes_in_group(GlobalConstants.SKYBOX_GROUP)
	if skyboxes != null and skyboxes.size() > 0 and skyboxes[0] is Skybox:
		skyboxes[0].set_target(onready_paths.camera_focus)