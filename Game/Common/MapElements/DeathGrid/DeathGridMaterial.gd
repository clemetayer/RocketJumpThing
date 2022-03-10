extends MeshInstance
# The deathgrid shader material controler

##### VARIABLES #####
#---- EXPORTS -----
export(NodePath) var target


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_size()
	_update_position()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_update_position()


##### PROTECTED METHODS #####
func _update_size() -> void:
	var size = mesh.size
	mesh.surface_get_material(0).set_shader_param("size", size)


func _update_position() -> void:
	var target_pos = get_node(target).global_transform.origin
	mesh.surface_get_material(0).set_shader_param("target_pos", target_pos)
