extends StaticBody
# class_name Class
# A wall that is breakable depending on the signal that is given on trigger-use

##### VARIABLES #####
#---- EXPORTS -----
export (Dictionary) var properties setget set_properties


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'collision_layer' in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if 'collision_mask' in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask


##### SIGNAL MANAGEMENT #####
#==== Qodot =====
func use() -> void:
	self.queue_free()
