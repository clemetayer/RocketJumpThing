tool
extends RotatingSpatial
# A slightly different version of the rotating spatial from the main menu

##### VARIABLES #####
#---- CONSTANTS -----
const GRADIENT_SHADER_PARAM_NAME := "color_gradient"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_cube_faces := $"CubeFaces"

##### PUBLIC METHODS #####
# returns the material on the border of the cube
func get_border_material() -> SpatialMaterial:
	return $LightBorder.get_surface_material(0)

# returns the gradient on one face of the cube (this should also update the other faces)
func get_face_gradient() -> GradientTexture:
	return onready_cube_faces.get_child(0).get_surface_material(0).get_shader_param(GRADIENT_SHADER_PARAM_NAME) 

# updates the cube faces gradient (color 1)
func update_gradient_1(col : Color) -> void:
	var gradient = _get_gradient()
	gradient.gradient.set_color(0,col)
	_get_face_material().set_shader_param(GRADIENT_SHADER_PARAM_NAME,gradient)

# updates the cube faces gradient (color 2)
func update_gradient_2(col : Color) -> void:
	var gradient = _get_gradient()
	gradient.gradient.set_color(1,col)
	_get_face_material().set_shader_param(GRADIENT_SHADER_PARAM_NAME,gradient)

##### PROTECTED METHODS #####
func _get_face_material() -> ShaderMaterial:
	return onready_cube_faces.get_child(0).get_surface_material(0) # gets only the gradient of the first child, since they should share the same texture

func _get_gradient() -> GradientTexture:
	return _get_face_material().get_shader_param(GRADIENT_SHADER_PARAM_NAME)
