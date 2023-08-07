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
# updates the cube faces gradient
func update_gradient(gradient : GradientTexture) -> void:
	var material = onready_cube_faces.get_child(0).get_surface_material(0) # gets only the gradient of the first child, since they should share the same texture
	material.set_shader_param(GRADIENT_SHADER_PARAM_NAME,gradient)
