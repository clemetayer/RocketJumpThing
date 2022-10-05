extends CollisionObject
class_name Collidable
# a standard class for everything that can be collided with

##### VARIABLES #####
#---- CONSTANTS -----
const TB_COLLIDABLE_MAPPER := [
	["collision_layer", "collision_layer"], ["collision_layer", "collision_mask"]
]  # mapper for TrenchBroom parameters
#---- EXPORTS -----
export(Dictionary) var properties


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_init_func()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_COLLIDABLE_MAPPER)


# init function to override
func _init_func() -> void:
	_set_TB_params()
