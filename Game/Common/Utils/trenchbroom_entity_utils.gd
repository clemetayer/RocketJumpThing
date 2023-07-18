extends Reference
class_name TrenchBroomEntityUtils
# an utility class to for trenchbroom entities

##### VARIABLES #####
#---- CONSTANTS -----
const TB_TR_MAPPER := {
	"tutorial_scene_move_tutorial": TranslationKeys.TUTORIAL_MOVE,
	"tutorial_scene_jump_tutorial": TranslationKeys.TUTORIAL_JUMP,
	"tutorial_scene_BHOP_tutorial": TranslationKeys.TUTORIAL_BHOP,
	"tutorial_scene_strafe_tutorial": TranslationKeys.TUTORIAL_STRAFE,
	"tutorial_scene_air_control_tutorial": TranslationKeys.TUTORIAL_AIR_CONTROL,
	"tutorial_scene_checkpoint_tutorial": TranslationKeys.TUTORIAL_CHECKPOINT,
	"tutorial_scene_2_slide_1": TranslationKeys.TUTORIAL_SLIDE_1,
	"tutorial_scene_2_slide_2": TranslationKeys.TUTORIAL_SLIDE_2,
	"tutorial_wall_ride_1": TranslationKeys.TUTORIAL_WALL_RIDE,
	"tutorial_rockets_1": TranslationKeys.TUTORIAL_ROCKETS,
	"tutorial_rockets_2": TranslationKeys.TUTORIAL_ROCKET_JUMP,
	"tutorial_rockets_3": TranslationKeys.TUTORIAL_ROCKET_WALL_JUMP,
	"tutorial_rockets_4": TranslationKeys.TUTORIAL_ROCKET_PADS
}
const TB_TRUE := 1  # true value for trenchbroom


##### PROTECTED METHODS #####
# maps the trenchbroom properties to the corresponding variables
# mapper : [["tb_property as a string","gd_property as a string"],...]
static func _map_trenchbroom_properties(
	object: Object, properties: Dictionary, mapper: Array
) -> void:
	for param in mapper:
		_map_trenchbroom_property(object, properties, param)


# maps one trenchbroom property
static func _map_trenchbroom_property(
	object: Object, properties: Dictionary, mapper: Array
) -> void:
	if mapper.size() == 2:
		if mapper[0] is String and mapper[1] is String:
			if mapper[0] in properties and mapper[1] in object:
				object.set(mapper[1], properties[mapper[0]])
			else:
				DebugUtils.log_stacktrace(
					"One of the property of the mapper %s is either not in self or _properties" % [mapper],
					DebugUtils.LOG_LEVEL.error
				)
		else:
			DebugUtils.log_stacktrace(
				"One of the mapper %s element is not a String" % [mapper], DebugUtils.LOG_LEVEL.error
			)
	else:
		DebugUtils.log_stacktrace(
			"Mapper %s does not have exactly 2 elements" % [mapper], DebugUtils.LOG_LEVEL.error
		)
