tool
extends StaticBody
class_name StaticBodyGroupSolidEntity
# Checkpoint entity declaration

export (Dictionary) var properties setget set_properties


func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'collision_layer' in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if 'collision_mask' in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask
