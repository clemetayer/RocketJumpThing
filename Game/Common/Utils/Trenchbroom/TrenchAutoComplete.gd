tool
extends Node
class_name TrenchAutoComplete
# A script to complete the Qodot full build, to set collisions and other things automatically
# Should be an editor tool ONLY

##### ENUMS #####
enum body_type { static_body, kinematic_body, rigid_body, area }

##### VARIABLES #####
#---- EXPORTS -----
export (Array, Dictionary) var TRENCH_PARAMS setget _set_trench_params, _get_trench_params  # Dictionary of parameters to change
export (bool) var BUILD setget _set_build_value, _get_build_value


##### PROTECTED METHODS #####
func _set_trench_params(new_params: Array):
	if Engine.editor_hint:
		for i in range(new_params.size()):
			var el = new_params[i]
			if el.size() <= 0:
				new_params[i] = {
					"path": NodePath(),
					"collisions":
					{
						"layer": 2,
						"mask": 5,
					}
				}
			elif el.path == null:
				new_params[i].path = NodePath()
			elif el.collisions == null:
				new_params[i].collisions = {
					"layer": 2,
					"mask": 5,
				}
			elif el.collisions.layer == null:
				new_params[i].collisions.layer = 2
			elif el.collisions.mask == null:
				new_params[i].collisions.mask = 5
		TRENCH_PARAMS = new_params


func _get_trench_params() -> Array:
	return TRENCH_PARAMS


func _set_build_value(new_val: bool):
	if Engine.editor_hint:
		for i in range(TRENCH_PARAMS.size()):
			var param = TRENCH_PARAMS[i]
			if param == null:
				print("TRENCH_PARAMS[%d] is null !" % i)
			elif param.path == null or get_node_or_null(param.path) == null:
				print("TRENCH_PARAMS[%d].path was not set correctly !" % i)
			else:
				var node = get_node(param.path)
				node.collision_layer = param.collisions.layer
				node.collision_mask = param.collisions.mask
		BUILD = false


func _get_build_value() -> bool:
	return BUILD
