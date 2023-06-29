extends Sprite3D
# A rocket target, usefull to know exactly where and when the rocket will hit

##### VARIABLES #####
#---- CONSTANTS -----
const MAX_SCALE = 10.0
const MAX_DIST = 10.0


##### PUBLIC METHODS #####
func set_pos(hit_pos: Vector3, normal: Vector3) -> void:
	global_transform.origin = hit_pos
	if normal == Vector3.UP or normal == Vector3.DOWN:
		rotation.x = PI / 2.0
	else:
		look_at(hit_pos + normal, Vector3.UP)


func update_scale(distance: float) -> void:
	if distance <= MAX_DIST:
		modulate.a = 1.0
		var scale_val := distance / MAX_DIST * MAX_SCALE
		scale = Vector3(scale_val, scale_val, 1.0)
	else:
		modulate.a = 0.0
