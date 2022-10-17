extends Reference
class_name TrenchBroomEntityUtils
# an utility class to map trenchbroom parameters


##### PROTECTED METHODS #####
# maps the trenchbroom properties to the corresponding variables
# mapper : [["tb_property as a string","gd_property as a string"],...]
static func _map_trenchbroom_properties(object: Object, properties: Dictionary, mapper: Array) -> void:
	for param in mapper:
		_map_trenchbroom_property(object, properties, param)


# maps one trenchbroom property
static func _map_trenchbroom_property(object: Object, properties: Dictionary, mapper: Array) -> void:
	if mapper.size() == 2:
		if mapper[0] is String and mapper[1] is String:
			if mapper[0] in properties and mapper[1] in object:
				object.set(mapper[1], properties[mapper[0]])
			else:
				Logger.error(
					(
						"One of the property of the mapper %s is either not in self or _properties, at %s"
						% [mapper, DebugUtils.print_stack_trace(get_stack())]
					)
				)
		else:
			Logger.error(
				(
					"One of the mapper %s element is not a String, at %s"
					% [mapper, DebugUtils.print_stack_trace(get_stack())]
				)
			)
	else:
		Logger.error(
			(
				"Mapper %s does not have exactly 2 elements, at %s"
				% [mapper, DebugUtils.print_stack_trace(get_stack())]
			)
		)
