extends Particles
# A simple particle emitter of flat polygons that are scaling up

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
var _size := Vector3.ONE  # size of the mesh
var _color := Color.white  # color of the mesh (goes to transparent)
var _sides := 3  # number of sides of the polygon
var _angle := Vector3.ZERO  # direction of the particle emitter


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_duplicate_common_elements()
	_set_trench_params()
	rotation_degrees = _angle
	draw_pass_1.size = Vector3(_size.x, 0, _size.z)
	draw_pass_1.material.set_shader_param("sides", _sides)
	process_material.color_ramp.gradient.colors[0] = _color
	process_material.color_ramp.gradient.colors[1] = Color(_color.r, _color.g, _color.b, 0)


##### PROTECTED METHODS #####
func _set_trench_params() -> void:
	if properties.has("size"):
		_size = properties["size"]
	if properties.has("color"):
		_color = properties["color"]
	if properties.has("sides"):
		_sides = properties["sides"]
	if properties.has("angle"):
		_angle = properties["angle"]


# makes some elements unique to avoid modifying other same particles
func _duplicate_common_elements() -> void:
	process_material = process_material.duplicate()
	draw_pass_1 = draw_pass_1.duplicate()
	draw_pass_1.material = draw_pass_1.material.duplicate()
