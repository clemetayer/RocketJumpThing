tool
extends OmniLight
# A basic script for the omni light entity

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties setget set_properties


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties():
	if "energy" in properties:
		set_param(Light.PARAM_ENERGY, properties["energy"])

	if "range" in properties:
		set_param(Light.PARAM_RANGE, properties["range"])

	if "specular" in properties:
		set_param(Light.PARAM_SPECULAR, properties["specular"])

	if "shadow_mode" in properties:
		omni_shadow_mode = properties["shadow_mode"]

	if "color" in properties:
		set_color(properties["color"])

	if "shadow_enabled" in properties:
		shadow_enabled = properties["shadow_enabled"]

	set_shadow(true)
	set_bake_mode(Light.BAKE_INDIRECT)
	set_shadow_reverse_cull_face(true)

	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				set_owner(edited_scene_root)
