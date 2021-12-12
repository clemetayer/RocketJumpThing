tool
extends StaticBody
class_name StaticBodyGroupSolidEntity
# Standard entity to group brushes into one static body (with correct collision layer/mask)

##### VARIABLES #####
#---- EXPORTS -----
export (Dictionary) var properties setget set_properties


##### PROTECTED METHODS #####
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'collision_layer' in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if 'collision_mask' in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask
