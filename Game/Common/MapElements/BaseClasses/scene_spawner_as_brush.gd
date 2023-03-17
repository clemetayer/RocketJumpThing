extends Spatial
# An simple utility script to "spawn" a point class as a brush
# Useful to be used with groups

##### VARIABLES #####
#---- CONSTANTS -----
const POINT_SPAWNER_AS_BRUSH_MAPPER := [["scene_path", "_scene_path"]]

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _scene_path: String  # path of the scene


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	_spawn_scene()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, POINT_SPAWNER_AS_BRUSH_MAPPER
	)


func _spawn_scene() -> void:
	if FunctionUtils.scene_path_valid(_scene_path):
		var scene = load(_scene_path).instance()
		if scene.get("properties") != null:
			scene.properties = properties
		add_child(scene)
